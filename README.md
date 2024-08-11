# 基于深度学习和Shack-Hartmann波前传感器的波前重建

## Shack-Hartmann波前探测系统仿真

- 使用Matlab根据光场的传播原理[1]实现Shack-Hartmann波前探测系统仿真

- 核心内容

  - 基于zernike多项式[2]和 Random matrix enlargement[3]生成复杂的光场波前

  <img src=".\img\波前生成.png" alt="波前生成" style="zoom:50%;" />

  - 根据光场的传播原理和透镜成像原理[1]实现的Shack-Hartmann波前探测仿真系统
  - 实现模式法[2]波前恢复

  <img src=".\img\光场成像系统.png" alt="光场成像系统" style="zoom:50%;" />

  

## 基于深度学习的波前恢复方法

- 使用U型残差网络实现的波前恢复方法

  - 利用zernike多项式和 Random matrix enlargement等方法生成复杂的光场波前作为网络训练的数据集

  <img src=".\img\数据集.png" alt="数据集" style="zoom:50%;" />

  - 基于深度学习的波前恢复方法的具体实现

  <img src=".\img\深度学习网络.png" alt="深度学习网络" style="zoom:50%;" />

  

## 参考文献：

[1]:李俊昌, 熊秉衡. 信息光学教程[M]. Ke xue chu ban she, 2017.

[2]:胡乐佳. 显微系统中基于波前探测与深度学习的像差校正方法研究[D]. 杭州: 浙江大学, 2021.

[3]:Wang K, Kemao Q, Di J, et al. Deep learning spatial phase unwrapping: a comparative review[J]. Advanced Photonics Nexus, 2022, 1(1): 014001-014001.

