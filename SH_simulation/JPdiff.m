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
%% 光场初始化
x = linspace(-pixelSizeM.*r./2,pixelSizeM.*r./2,r);
[X,Y]=meshgrid(x,x);
alpha=pi/2.00; %参考光与 x 轴间的夹角
beita=pi*0.8; %参考光与 y 轴间的夹角
UobPhase=(X*cos(alpha)+Y*cos(beita));
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %预设物
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure,imshow(UobPhase,[]),title('物光分布')              %显示物分布
%%
UobT=Uob.*exp(-1i.*k./2./Lo.*(X.^2+Y.^2)); %透镜后表面的

H=exp(1i.*k.*Lo./(1i./lamda./Lo)).*exp(1i.*k./2./Lo.*(X.^2+Y.^2)); %传递函数
Uout=fftshift(ifft2(fft2(UobT).*fft2(H).*pixelSizeM.^4).*(1./(r.*pixelSizeM)).^2.*r.^2);
figure,imshow(H)