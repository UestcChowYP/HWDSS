import numpy as np
import scipy
import torchvision
from matplotlib import pyplot as plt
from PaperNet import *
from dataset import Mydata


def imshow(name, title_str):
    plt.figure()
    plt.imshow(name, cmap='gray')
    plt.title(title_str)
    plt.show()


def raw_read(path, mat_name):
    img_raw = scipy.io.loadmat(path)
    img_raw = np.array(img_raw[mat_name])  # 将matlab数据赋值给python变量
    return img_raw


# 读取第img_num张图像
img_num = 40000
transforms_img = torchvision.transforms.Compose([torchvision.transforms.ToPILImage(),
                                                 torchvision.transforms.Resize([256, 256]),
                                                torchvision.transforms.ToTensor()])
images_dir = 'dataset/trainTest'
targets_dir = 'dataset/trainTest_target'
train_dataset = Mydata(images_dir, targets_dir, transforms_img)
# 加载模型
model = torch.load("model_dict/PaperUnetTest14")
Phase_net = PaperUNet()
Phase_net.load_state_dict(model)
# image, target = train_dataset[img_num-1]
# 读取标签
target = raw_read('dataset/trainTest_target/train_UobPhase{}.mat'.format(img_num), 'UobPhase')
# 哈特曼图像数据读取
img = raw_read('dataset/trainTest/train_Hart{}.mat'.format(img_num), 'IimR')
img = torch.Tensor(img)
img = transforms_img(img)
img = torch.reshape(img, (1, 1, 256, 256))
# 输出
output_test = Phase_net(img)
# 将张量转换为Numpy数组
output_array = output_test.detach().cpu().numpy()
# 查看
output_array = output_array.squeeze()
imshow(target, 'target')
imshow(output_array, 'output_array')
# 保存数组
np.savetxt('dataset/train_out/outputTest.txt', output_array)

