clc;clear;close all;
lamda=6328*10^(-10);k=2*pi/lamda;                                          %赋值波长,单位:米,波矢
Lo=14.1e-3;                                                                 %赋值透镜的焦距,物面的尺寸Lo,单位:米
c=240;r=c;                                                                  %物面采样数
lensNum=16;
pixelSize=c/lensNum;                                                        
pixelSizeM=0.04e-3;                                                      %单个像素大小0.02mm,即0.02e-3m
pixelSizeReal=2/r;                                                      %使用归一化长度
N = 119;
zerNum=119;
zernikeAoutAll=zeros(N,zerNum);
%% 生成Zernike波前
% circ = 1;
%% 生成前N项zernike多项式
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % 生成归一化物光场坐标，孔径有效位置及坐标
[zernikeGroup] = zernikeN(rou,theta,N); % 生成前N项zernike多项式矩阵
%% 
for circ = 20481:40960
%% 随机生成波前相位
[ZerRandWave1,zernikeAout] = zernikeWaveFun(r, N, zernikeGroup);
initSize = round(rand.*8)+2;
[ZerRandWave2] = RandomWaveFun(initSize,r);
ZerRandWave = (ZerRandWave1+ZerRandWave2)/2;
% ZerRandWave = ZerRandWave2;
% figure,mesh(ZerRandWave),title('生成相位')
%% 加入噪声
ZerRandWaveOne = (ZerRandWave-min(ZerRandWave(:)))./(max(ZerRandWave(:))-min(ZerRandWave(:))); % 归一化
% ZerRandWaveUint = uint8(ZerRandWaveOne);
Aratio=rand().*0.0004;
Bratio=rand().*0.0002;
ZerRandWaveNoise=imnoise(ZerRandWaveOne,'gaussian',Aratio,Bratio); % 均值/方差
ZerRandWaveNoise=ZerRandWaveNoise.*(max(ZerRandWave(:))-min(ZerRandWave(:)))+min(ZerRandWave(:));
ZerRandWaveNoise(idxOut_normal)=0;
% figure,mesh(ZerRandWaveNoise()),title('噪声相位') 
%% 初始化输入光场
UobOrigin=ones(r,c);
UobPhase=double(ZerRandWaveNoise);
UobPhase(idxOut_normal)=nan;                                        %预设物
Uob=UobOrigin.*exp(1i.*UobPhase);
% figure,mesh(UobPhase),title('物光的相位分布')                                     %显示物分布
%% 计算SH探测结果
Iout = HartmanDiff(r,cirPosXY,Uob,pixelSize,pixelSizeM);
IimR = (Iout-min(Iout(:)))./(max(Iout(:))-min(Iout(:)));
IimRImp = zeros(256,256);
IimRImp(9:end-8,9:end-8)=IimR;
IimR=IimRImp;
% figure,imshow(IimR,[]),title('SH处的光场')
%% 保存生成的文件
UobPhase(idxOut_normal)=0;
UobPhaseImp = zeros(256,256);
UobPhaseImp(9:end-8,9:end-8)=UobPhase;
UobPhase=UobPhaseImp;
% figure,mesh(UobPhase),title('物光的相位分布') 
save(['直接再现数据集/trainTest_target/train_UobPhase',num2str(circ),'.mat'],'UobPhase');
save(['直接再现数据集/trainTest/train_Hart',num2str(circ),'.mat'],'IimR');
% imwrite(Iout./(max(Iout(:))),['直接再现数据集/train/train',num2str(circ),'.jpg']);
end
