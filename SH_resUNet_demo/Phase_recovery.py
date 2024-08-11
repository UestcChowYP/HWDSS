import time
from dataset import *  # 导入数据函数
from PaperNet import *  # 从外部引入网络模型

# 数据准备
train_images_dir = 'dataset/trainTest'
train_targets_dir = 'dataset/trainTest_target'
test_images_dir = 'dataset/train1'
test_targets_dir = 'dataset/train_target1'
transforms_img = torchvision.transforms.Compose([torchvision.transforms.ToPILImage(),
                                                 torchvision.transforms.Resize([256, 256]),
                                                torchvision.transforms.ToTensor()])
train_dataset = Mydata(train_images_dir, train_targets_dir, transforms_img)
test_dataset = Mydata(test_images_dir, test_targets_dir, transforms_img)
print(train_dataset)

# length 长度
train_data_size = len(train_dataset)
test_data_size = len(test_dataset)
print("训练数据集的长度为：{};测试数据集的长度为：{}".format(train_data_size, test_data_size))
print(torch.cuda.is_available())

# 利用 dataloader 来加载数据集
train_dataloader = DataLoader(train_dataset, batch_size=30, shuffle=True,)
test_dataloader = DataLoader(test_dataset, batch_size=30, shuffle=True)


# 从外部引入网络模型
# Phase_net = PaperUNet()
# 载入训练过的模型
model = torch.load("model_dict/PaperUnetTest13")
Phase_net = PaperUNet()
Phase_net.load_state_dict(model)
# 网络初始化
# for name, param in Phase_net.named_parameters():
#     if 'weight' in name:

#         nn.init.normal_(param, mean=0.5, std=0.1)
#     elif 'bias' in name:
#         nn.init.constant_(param, val=0.1)

# 将网络模型转为cuda
if torch.cuda.is_available():
    Phase_net = Phase_net.cuda()

# 创建损失函数
# loss_fn = nn.MSELoss()
loss_fn = nn.MSELoss(reduction="mean")

# 将损失函数转为cuda
if torch.cuda.is_available():
    loss_fn = loss_fn.cuda()

# 优化器
learning_rate = 1e-3
# optimizer = torch.optim.Adam(Phase_net.parameters(), lr=learning_rate)
optimizer = torch.optim.SGD(Phase_net.parameters(), learning_rate)

# 初始化训练网络的参数
# 训练次数
total_train_step = 0
# 测试次数
total_test_step = 0
# 训练的轮数
epoch = 10

# 添加tensorboard
writer = SummaryWriter("train_logs")

# 记录时间
start_time = time.time()

for i in range(epoch):
    print("第 {} 轮训练开始".format(i+1))

    # 开始模型训练
    # Phase_net.train()  # 有dropout层是必要
    for data_num, (images, targets) in enumerate(train_dataloader):
        optimizer.zero_grad()
        # images, targets = data
        # 读取后的数据转化为cuda
        if torch.cuda.is_available():
            images = images.cuda()
            targets = targets.cuda()
        outputs = Phase_net(images)
        loss = loss_fn(outputs, targets)
        # loss = torch.sqrt(loss_fn(outputs, targets))
        # 优化模型
        loss.backward()
        optimizer.step()

        print(
            "[Epoch %d/%d] [Batch %d/%d] [loss: %f]"
            % (i+1, epoch, data_num+1, len(train_dataloader), loss.item())
        )

        total_train_step += 1
        if total_train_step % 10 == 0:
            print("训练次数： {}, Loss: {}".format(total_train_step, loss.item()))
            writer.add_scalar("train_loss", loss.item(), total_train_step)
            end_time = time.time()
            print("训练{}所使用的时间为： {}".format(total_train_step, end_time-start_time))
        for name, param in Phase_net.named_parameters():
            print("参数名：", name)
            print("参数值：", param[0])
            print("梯度值：", param.grad[0])
            print("-----------")
            break
        # 验证步骤开始
        # Phase_net.eval()  # 有dropout层时必要
        # total_test_loss = 0
        # total_accuracy = 0
        # with torch.no_grad():
        #     for data in test_dataloader:
        #         images, targets = data
        #         # 读取后的数据转化为cuda
        #         if torch.cuda.is_available():
        #             images = images.cuda()
        #             targets = targets.cuda()
        #         outputs = Phase_net(images)
        #         loss_dev = loss_fn(outputs, targets)

                # total_test_loss = total_test_loss + loss.item()
        #         accuracy = total_test_loss / 50
        #         total_accuracy = total_accuracy + accuracy
        # print("验证数据集的Loss：{}".format(loss_dev))
        # print("验证数据集的正确率： {}".format(total_accuracy/test_data_size))
        # writer.add_scalar("test_loss", loss_dev.item(), total_test_loss)
        # writer.add_scalar("test_accuray", total_accuracy/test_data_size,total_test_loss)
        # total_test_loss += 1

#     torch.save(Phase_net,"Phase_net_{}".format(i+1))
#     # torch.save(Phase_net.state_dict(), "Phase_net_{}".format(i+1)")  # 官方推荐保存方法
#     print("已保存第 {} 轮学习模型".format(i+1))
#
# writer.close() # tensorboard --logdir

# 查看网络参数
# for name, param in Phase_net.named_parameters():
#     print("参数名：", name)
#     print("参数值：", param)
#     print("梯度值：", param.grad)
#     print("-----------")
# 保存模型
#     if i % 5 == 0:
    torch.save(Phase_net.state_dict(), "PaperUnetTest{}_test".format(i+18))
