import torch
from torch import nn
from torch.utils.data import DataLoader

from dataset import Mydata, transforms_img


# 下采样网络
class TestDownSampleLayer(nn.Module):
    def __init__(self, in_ch, out_ch):
        super(TestDownSampleLayer, self).__init__()
        self.Conv_BN_ReLU_2 = nn.Sequential(
            nn.Conv2d(in_channels=in_ch, out_channels=out_ch, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(),
            nn.Conv2d(in_channels=out_ch, out_channels=out_ch, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(),
        )
        self.downSample = nn.Sequential(
            nn.Conv2d(in_channels=out_ch, out_channels=out_ch, kernel_size=3, stride=2, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(),
        )

    def forward(self, x):
        """
        :param x:
        :return: out输出到深层，out_2输入到下一层，
        """
        out_deep = self.Conv_BN_ReLU_2(x)
        out_next = self.downSample(out_deep)
        return out_deep, out_next


# 上采样网络
class TestUpSampleLayer(nn.Module):
    def __init__(self, in_ch, out_ch):
        # 512-1024-512
        # 1024-512-256
        # 512-256-128
        # 256-128-64
        super(TestUpSampleLayer, self).__init__()
        self.Conv_BN_ReLU_2 = nn.Sequential(
            nn.Conv2d(in_channels=in_ch, out_channels=out_ch*2, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(out_ch*2),
            nn.ReLU(),
            nn.Conv2d(in_channels=out_ch*2, out_channels=out_ch*2, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(out_ch*2),
            nn.ReLU(),
        )
        self.upSample = nn.Sequential(
            nn.ConvTranspose2d(in_channels=out_ch*2, out_channels=out_ch, kernel_size=3, stride=2, padding=1,
                               output_padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(),
        )

    def forward(self, x, out):
        """
        :param x: 输入卷积层
        :param out:与上采样层进行cat
        :return:
        """
        x_out = self.Conv_BN_ReLU_2(x)
        x_out = self.upSample(x_out)
        return x_out


# ResUnet网络
class TestPhaseRecoverUNet(nn.Module):
    def __init__(self):
        super(TestPhaseRecoverUNet, self).__init__()
        out_channels = [2**(i+5) for i in range(5)]  # [32, 64, 128, 256, 512]
        # 下采样
        self.d1 = TestDownSampleLayer(1, out_channels[0])  # 1-32
        # 上采样
        self.u1 = TestUpSampleLayer(out_channels[0], out_channels[0])  # 512-1024-512
        # 输出
        self.o = nn.Sequential(
            nn.Conv2d(out_channels[0], 1, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(1),
            nn.Tanh
        )

    def forward(self, x):
        out_1, out1 = self.d1(x)  # out:torch.Size([1, 32, 540, 540]) torch.Size([1, 32, 270, 270])
        out5 = self.u1(out1, out_1)
        out = self.o(out5)
        out = out.squeeze()
        return out


if __name__ == '__main__':
    Phase_Recover = TestPhaseRecoverUNet()
    inputTest = torch.ones((10, 1, 270, 270))
    output = Phase_Recover(inputTest)
    print(output.shape)


