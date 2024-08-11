# _*_coding:utf-8_*_

import os  # 系统管理库

import numpy as np
import scipy
import torch
import torchvision
from torch.utils.data import Dataset, DataLoader
import matplotlib.pyplot as plt
from torch.utils.tensorboard import SummaryWriter


transforms_img = torchvision.transforms.Compose([torchvision.transforms.ToPILImage(),
                                                 torchvision.transforms.Resize([256, 256]),
                                                torchvision.transforms.ToTensor()
                                                 ])


class Mydata(Dataset):
    def __init__(self, images_dir_in, targets_dir_in, transform=None):
        self.images_dir = images_dir_in
        self.targets_dir = targets_dir_in
        self.img_path = os.listdir(self.images_dir)
        self.target_path = os.listdir(self.targets_dir)
        self.transforms = transform

    def __getitem__(self, idx):
        # 读取img
        img_name = self.img_path[idx]
        img_item_path = os.path.join(self.images_dir, img_name)
        img_data = scipy.io.loadmat(img_item_path)
        img = img_data['IimR']
        img_np = np.array(img)
        img = torch.from_numpy(img_np)
        # 读取target
        target_name = self.target_path[idx]
        target_item_path = os.path.join(self.targets_dir, target_name)
        target_data = scipy.io.loadmat(target_item_path)
        target = target_data['UobPhase']
        target_np = np.array(target)
        target = torch.Tensor(target_np)
        if self.transforms:
            # transforms方法如果有就先处理，然后再返回最后结果
            img = self.transforms(img)
        return img, target

    def __len__(self):
        return len(self.img_path)


# 数据读取测试
if __name__ == '__main__':
    # 检查输入图片大小/查看内容
    images_dir = 'dataset/trainTest'
    targets_dir = 'dataset/trainTest_target'
    train_dataset = Mydata(images_dir, targets_dir, transforms_img)
    # 查看图片
    img1, target1 = train_dataset[0]
    img1 = img1.squeeze()
    target1 = target1.squeeze()
    print(img1, img1.shape, target1, target1.shape, sep='\n'*2)
    plt.figure()
    plt.imshow(img1.squeeze(), cmap='gray')  # 交换矩阵顺序
    plt.title('test_image')
    plt.show()
    plt.figure()
    plt.imshow(target1.squeeze(), cmap='gray')  # 交换矩阵顺序
    plt.title('target1')
    plt.show()


    # target,mat文件直接读取
    # target_test = scipy.io.loadmat('dataset/trainTest_target/train_UobPhase1.mat')
    # target_test = target_test['ZerRandWave']
    # target_test = np.array(target_test)
    # target_test = torch.from_numpy(target_test)
    # print(target_test[270], target_test.shape)
    # img_test = scipy.io.loadmat('dataset/trainTest/train_Hart1.mat')
    # img_test = img_test['IimR']
    # img_test = np.array(img_test)
    # img_test = torch.from_numpy(img_test)
    # print(img_test[270], img_test.shape)
