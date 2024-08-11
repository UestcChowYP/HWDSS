clc;clear;close all;
c=512;r=c;                        %物面采样数
Uo=zeros(r,c);                    %预设物
d=30;a=10;                        %光栅常数和缝宽
for n=1:d:r                       %循环生成物(二维光栅)
   Uo(n:n+a,:)=1;
end
for m=1:d:c
   Uo (:,m:m+a)=1;
end
Uo=Uo(1:r,1:c);
figure,imshow(Uo,[]),title('物光分布')              %显示物分布
%%
%下面计算物光传递到透镜的衍射过程(S-FFT)
lamda=6328*10^(-10);k=2*pi/lamda;    %赋值波长,单位:米,波矢
Lo=0.0001;                   %赋值透镜的焦距,物面的尺寸Lo,单位:米
xo=linspace(-Lo/2,Lo/2,c);yo=linspace(-Lo/2,Lo/2,r);  %赋值物面的坐标
[xo,yo]=meshgrid(xo,yo);             %生成物面的坐标网格
do=0.00041;                         %物面到透镜的距离do,单位:米
L=c*lamda*do/Lo;                    %衍射光在透镜前表面上的尺寸L,单位:米
xl=linspace(-L/2,L/2,c);yl=linspace(-L/2,L/2,r); %赋值透镜前表面的坐标
[xl,yl]=meshgrid(xl,yl);               %生成透镜前表面的坐标网格
F0=exp(1i*k*do)/(1i*lamda*do)*exp(1i*k/2/do*(xl.^2+yl.^2));
F=exp(1i*k/2/do*(xo.^2+yo.^2));
FU=(Lo*Lo/c/c).*fftshift(fft2(Uo.*F)); 
U1=F0.*FU;                         %透镜前表面上的光场复振幅分布
I1=U1.*conj(U1);                     %透镜前表面上的光强分布
figure,imshow(I1,[]),title('透镜前表面的光强分布')
%%
%下面计算焦平面上的频谱
Uf=fftshift(fft2(Uo));            %计算后焦面上的光场分布
If=Uf.*conj(Uf);                  %后焦面上的光强分布
figure,imshow(If,[0,max(If(:))/10000]),title('后焦面上的光强分布')
