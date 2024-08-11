%% 哈特曼波前探测，模式法再现
clc;clear;close all;
%% 数据初始化
% 以光瞳的归一化长度为1
lamda=6328*10^(-10);k=2*pi/lamda;                                          %赋值波长,单位:米,波矢
Lo=14.1e-3;%14.1e-3                                                         %赋值透镜的焦距,物面的尺寸Lo,单位:米
c=540;r=c;                                                                  %物面采样数
lensNum=36;
pixelSize=c/lensNum;                                                       %子孔径像素数量              
pixelSizeM=0.02e-3;                                                      %单个像素大小0.02mm,即0.02e-3m
pixelSizeReal=2/r;                                                      %使用归一化长度
%% 生成前N项zernike多项式
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % 生成归一化物光场坐标，孔径有效位置及坐标
[zernikeGroup] = zernikeN(rou,theta,N); % 生成前N项zernike多项式矩阵
%% 计算zernike多项式的波前斜率
[zernikeGradNo0] = WavefrontGrad(lensNum,N,rou,zernikeGroup,pixelSizeM,cirPosXY);
%% 伪逆矩阵
zernikeGradT = pinv(zernikeGradNo0);
%% 随机生成波前相位
[ZerRandWave,zernikeAout] = zernikeWaveFun(r, 15, zernikeGroup);
% ZerRandWaveGradient=gradient(ZerRandWave, pixelSizeM, pixelSizeM);
% figure,mesh(ZerRandWaveGradient),title('波前斜率分布')
%% 初始化输入光场
UobOrigin=ones(r,c);
% UobPhase=zernikeGroup(:,:,11);
% UobPhase=peaks(r);
% UobPhase=RandomWaveFun(6,c);
UobPhase=ZerRandWave;
% UobPhase(UobPhase==0)=nan;
Uob=UobOrigin.*exp(1i.*UobPhase);                                           %预设物
IlenOri=zeros(r,c);
Ilen=zeros(r,c);
figure,mesh(UobPhase),title('物光的相位分布')                                     %显示物分布
%% 计算SH探测结果
% 原始位置
IoutOri = HartmanDiff(r,cirPosXY,UobOrigin,pixelSize,pixelSizeM);
% 引入像差后的位置
Iout = HartmanDiff(r,cirPosXY,Uob,pixelSize,pixelSizeM);
% Iout = FNRdiff(r,cirPosXY,Uob,pixelSize,pixelSizeM,Lo,lamda);
IimR = (Iout-min(Iout(:)))./(max(Iout(:))-min(Iout(:))).*255;
IoutEq = histeq(uint8(IimR));
figure,mesh(Iout),title('SH处的光场')
figure,imshow(Iout,[]),title('SH处的光场')
% 计算前后的质心位置
[PositionXOri, PositionYOri] = PositionFunc(lensNum, pixelSize, IoutOri, cirPosXY, pixelSizeM.*r/2);
[PositionX, PositionY] = PositionFunc(lensNum, pixelSize, Iout, cirPosXY, pixelSizeM.*r/2);
% 计算波前斜率
indexPos = cirPos~=0;
PositionXOriT=PositionXOri';
PositionYOriT=PositionYOri';
PositionXT = PositionX';
PositionYT = PositionY';
gradientDeltaX = PositionXT(indexPos)-PositionXOriT(indexPos);
gradientDeltaY = PositionYT(indexPos)-PositionYOriT(indexPos);
gradientX=gradientDeltaX./Lo./lamda.*2.*pi;
gradientY=gradientDeltaY./Lo./lamda.*2.*pi;%2.*Lo./540./pixelSizeM....Lo./(lamda.*Lo./pixelSizeM./c)
gradientXList = gradientX(:);
gradientYList = gradientY(:);
gradientList = zeros(length(gradientXList)*2, 1);
for idx = 1:length(gradientXList)
    gradientList(idx*2-1,1)=gradientXList(idx);
    gradientList(idx*2,1)=gradientYList(idx);
end
%% nernike分解系数计算
zernikeRatio = zernikeGradT*gradientList;
figure,plot(gradientList),title('计算的波前斜率')
zernikeRe=zeros(size(rou));
for i=1:N
    zernikeRe = zernikeRe + zernikeRatio(i).*zernikeGroup(:,:,i);
end
% zernikeRe = (zernikeRe-min(zernikeRe(:)))./(max(zernikeRe(:))-min(zernikeRe(:)));
zernikeRe(idxOut_normal)=nan;
% figure,mesh(zernikeRe./max(zernikeRe(:))),title('再现结果')
figure,mesh(zernikeRe),title('再现结果')
figure,plot(zernikeAout),title('生成zernike系数')
figure,plot(zernikeRatio),title('再现zernike系数')
UobPhase_out = UobPhase.*double(idxIn_normal);
% save(['UobPhase_test',num2str(N),'.mat'],'UobPhase_out');
% imwrite(Iout./(max(Iout(:))),'test.jpg');