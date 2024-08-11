%% 哈特曼波前探测，模式法再现
clc;clear;close all;
%% 数据初始化
% 以光瞳的归一化长度为1
lamda=6328*10^(-10);k=2*pi/lamda;                                          %赋值波长,单位:米,波矢
Lo=14.1e-3;                                                                 %赋值透镜的焦距,物面的尺寸Lo,单位:米
c=540;r=c;                                                                  %物面采样数
lensNum=36;
pixelSize=c/lensNum;                                                       %子孔径像素数量              
pixelSizeM=0.02e-3;                                                      %单个像素大小0.02mm,即0.02e-3m
pixelSizeReal=2/r;                                                      %使用归一化长度
%% 生成前N项zernike多项式
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % 生成归一化物光场坐标，孔径有效位置及坐标
[zernikeGroup] = zernikeN(rou,theta,N); % 生成前N项zernike多项式矩阵
%% 重建波前
idxOut = rou>1;
ZernikeARea = importdata('output9.txt');
WaveFunRe = zeros(size(theta));
for idxi = 1:N
    WaveFunRe = WaveFunRe + zernikeGroup(:,:,idxi).*ZernikeARea(idxi);
end
WaveFunRe(idxOut)=nan;
figure,mesh(WaveFunRe),title('重建的相位分布') 
figure,plot(ZernikeARea),title('重建的系数')
%% 原来的波前
ZernikeAOri = importdata('数据集/训练集target/ZernikeA_train1.xlsx', 'ReadVariableNames', false);
ZernikeAOri = ZernikeAOri(1,:);
WaveFunOri= zeros(size(theta));
for idxi = 1:N
    WaveFunOri = WaveFunOri + zernikeGroup(:,:,idxi).*ZernikeAOri(idxi);
end
WaveFunOri(idxOut)=nan;
figure,mesh(WaveFunOri),title('原来的相位分布') 
figure,plot(ZernikeAOri),title('原始的系数')