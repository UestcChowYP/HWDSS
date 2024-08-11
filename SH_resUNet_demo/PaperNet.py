import torch
from torch import nn
from torch.utils.data import DataLoader

from dataset import Mydata, transforms_img


# 下采样网络
class DownSampleLayer(nn.Module):
    def __init__(self, in_ch, out_ch):
        super(DownSampleLayer, self).__init__()
        self.downSample = nn.Sequential(
            nn.Conv2d(in_channels=in_ch, out_channels=out_ch, kernel_size=3, stride=2, padding=1),
        )

    def forward(self, x):
        """
        :param x:
        :return:out_next输入到下一层，
        """
        out_next = self.downSample(x)
        return out_next


# 上采样网络
class UpSampleLayer(nn.Module):
    def __init__(self, in_ch, out_ch):
        super(UpSampleLayer, self).__init__()
        self.upSample = nn.Sequential(
            nn.ConvTranspose2d(in_channels=in_ch, out_channels=out_ch, kernel_size=3, stride=2, padding=1,
                               output_padding=1),
            nn.Conv2d(in_channels=out_ch, out_channels=out_ch, kernel_size=3, stride=1, padding=1),
        )

    def forward(self, x):
        """
        :param x: 输入卷积层
        :return:x_out:与上采样层进行cat
        """
        x_out = self.upSample(x)
        return x_out


# Res_block
class ResBlock(nn.Module):
    def __init__(self, in_ch, out_ch):
        super(ResBlock, self).__init__()
        self.RB_outChannel = int(out_ch / 4)
        self.RB1 = nn.Sequential(
            nn.Conv2d(in_channels=in_ch, out_channels=out_ch, kernel_size=1, stride=1),
            nn.BatchNorm2d(out_ch),
        )
        self.RB3 = nn.Sequential(
            nn.BatchNorm2d(in_ch),
            nn.ReLU(),
            nn.Conv2d(in_channels=in_ch, out_channels=self.RB_outChannel, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(self.RB_outChannel),
            nn.ReLU(),
            nn.Conv2d(in_channels=self.RB_outChannel, out_channels=self.RB_outChannel, kernel_size=3, stride=1, padding=1),
        )
        self.RB5 = nn.Sequential(
            nn.BatchNorm2d(in_ch),
            nn.ReLU(),
            nn.Conv2d(in_channels=in_ch, out_channels=self.RB_outChannel, kernel_size=5, stride=1, padding=2),
            nn.BatchNorm2d(self.RB_outChannel),
            nn.ReLU(),
            nn.Conv2d(in_channels=self.RB_outChannel, out_channels=self.RB_outChannel, kernel_size=5, stride=1, padding=2),
        )
        self.RB7 = nn.Sequential(
            nn.BatchNorm2d(in_ch),
            nn.ReLU(),
            nn.Conv2d(in_channels=in_ch, out_channels=self.RB_outChannel, kernel_size=7, stride=1, padding=3),
            nn.BatchNorm2d(self.RB_outChannel),
            nn.ReLU(),
            nn.Conv2d(in_channels=self.RB_outChannel, out_channels=self.RB_outChannel, kernel_size=7, stride=1, padding=3),
        )
        self.RB9 = nn.Sequential(
            nn.BatchNorm2d(in_ch),
            nn.ReLU(),
            nn.Conv2d(in_channels=in_ch, out_channels=self.RB_outChannel, kernel_size=9, stride=1, padding=4),
            nn.BatchNorm2d(self.RB_outChannel),
            nn.ReLU(),
            nn.Conv2d(in_channels=self.RB_outChannel, out_channels=self.RB_outChannel, kernel_size=9, stride=1, padding=4),
        )

    def forward(self, x):
        """
        :param x:
        :return: out输出到深层，out_2输入到下一层，
        """
        out_deep1 = self.RB1(x)
        out_deep3 = self.RB3(x)
        out_deep5 = self.RB5(x)
        out_deep7 = self.RB7(x)
        out_deep9 = self.RB9(x)
        out_con = torch.cat((out_deep3, out_deep5, out_deep7, out_deep9), 1)
        out = torch.add(out_con, out_deep1)
        return out


# ResUnet网络
class PaperUNet(nn.Module):
    def __init__(self):
        super(PaperUNet, self).__init__()
        out_channels = [2**(i+5) for i in range(5)]  # [32, 64, 128, 256, 512]
        # Res_block
        self.RB1 = ResBlock(1, out_channels[0])
        self.RB1_ = ResBlock(out_channels[0], out_channels[0])
        self.RB2 = ResBlock(out_channels[1], out_channels[1])
        self.RB3 = ResBlock(out_channels[2], out_channels[2])
        self.RB4 = ResBlock(out_channels[3], out_channels[3])
        # 下采样
        self.d1 = DownSampleLayer(out_channels[0], out_channels[1])  # 1-32
        self.d2 = DownSampleLayer(out_channels[1], out_channels[2])
        self.d3 = DownSampleLayer(out_channels[2], out_channels[3])
        # 上采样
        self.u1 = UpSampleLayer(out_channels[3], out_channels[2])  # 512-1024-512
        self.u2 = UpSampleLayer(out_channels[2], out_channels[1])
        self.u3 = UpSampleLayer(out_channels[1], out_channels[0])
        # 输出
        self.o = nn.Sequential(
            nn.Conv2d(out_channels[0], 1, kernel_size=1, stride=1, padding=0),
        )

    def forward(self, x):
        rb32co_out = self.RB1(x)
        d32_out = self.d1(rb32co_out)
        rb64co_out = self.RB2(d32_out)
        d64_out = self.d2(rb64co_out)
        rb128co_out = self.RB3(d64_out)
        d256_out = self.d3(rb128co_out)
        rb256mid_out = self.RB4(d256_out)
        u1_out = self.u1(rb256mid_out)
        u1_sum = torch.add(u1_out, rb128co_out)
        u1rb_out = self.RB3(u1_sum)
        u2_out = self.u2(u1rb_out)
        u2_sum = torch.add(u2_out, rb64co_out)
        u2rb_out = self.RB2(u2_sum)
        u3_out = self.u3(u2rb_out)
        u3_sum = torch.add(u3_out, rb32co_out)
        u3rb_out = self.RB1_(u3_sum)
        out = self.o(u3rb_out)
        out = out.squeeze()
        return out


if __name__ == '__main__':
    Phase_Recover = PaperUNet()
    inputTest = torch.ones((1, 1, 256, 256))
    output = Phase_Recover(inputTest)
    # output = TestDS(inputTest)
    # output = TestUS(output)
    print(output.shape)


