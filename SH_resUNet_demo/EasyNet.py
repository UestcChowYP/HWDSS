import torch
from torch import nn


class NoiseReduce(nn.Module):
    def __init__(self):
        super(NoiseReduce, self).__init__()
        self.model1 = nn.Sequential(
            nn.Conv2d(1, 8, kernel_size=(3, 3), padding=1),
            nn.Conv2d(8, 16, kernel_size=(3, 3), padding=1),
            nn.Conv2d(16, 16, kernel_size=(3, 3), padding=1),
            # nn.Conv2d(16, 16, kernel_size=(3, 3), padding=1),
            # nn.Sigmoid(),
            # nn.Conv2d(16, 32, kernel_size=(3, 3), padding=1),
            # nn.Sigmoid(),
            # nn.Conv2d(32, 16, kernel_size=(3, 3), padding=1),
            nn.Conv2d(16, 16, kernel_size=(3, 3), padding=1),
            nn.Conv2d(16, 16, kernel_size=(3, 3), padding=1),
            nn.Conv2d(16, 8, kernel_size=(3, 3), padding=1),
            nn.Conv2d(8, 1, kernel_size=(3, 3), padding=1),
        )

    def forward(self, x):
        x = self.model1(x)
        x = x.squeeze()
        return x


if __name__ == '__main__':
    Phase_Recover = NoiseReduce()
    inputTest = torch.ones((1, 1, 270, 270))
    output = Phase_Recover(inputTest)
    print(output)
