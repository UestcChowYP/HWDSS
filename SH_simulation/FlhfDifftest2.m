clc;clear;close all;
c=15;r=c;                        %物面采样数
lensNum=36;
pixelSize=c/lensNum;
lamda=6328*10^(-10);k=2*pi/lamda;    %赋值波长,单位:米,波矢
Lo=14.1e-3;                   %赋值透镜的焦距,物面的尺寸Lo,单位:米
x = linspace(-1,1,r);
[X,Y]=meshgrid(x,x);
%%
alpha=pi/2.00; %参考光与 x 轴间的夹角
beita=pi*0.53; %参考光与 y 轴间的夹角
UobPhase=(X*cos(alpha)+Y*cos(beita));
figure,mesh(UobPhase)
%%
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %预设物
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure(1),mesh(UobPhase),title('物光分布')              %显示物分布
%% 整个光场
UfWhole=fftshift(fft2(Uob));            %计算后焦面上的光场分布
IfWhole=UfWhole.*conj(UfWhole);                  %后焦面上的光强分布
% figure,mesh(real(UfWhole)),title('后焦面上的光强分布')
figure(2),mesh(IfWhole),title('后焦面上的光强分布')
figure(3),imshow(IfWhole/max(IfWhole(:)), [0,1/1e3]),title('后焦面上的光强分布')
A = k.*UobPhase;
figure,mesh(A)