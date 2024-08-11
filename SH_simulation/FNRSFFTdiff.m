clc;clear;close all;
r=512;c=r;                        %物面采样数
Uo=zeros(c,r);                    %预设物
d=30;a=10;                        %光栅常数和缝宽
for n=1:d:c                       %循环生成物(二维光栅)
   Uo(n:n+a,:)=1;
end
for m=1:d:r
   Uo (:,m:m+a)=1;
end
Uo=Uo(1:c,1:r);
% figure,imshow(Uo,[]),title('物光分布')              %显示物分布
%%
%下面计算物光传递到透镜的衍射过程(S-FFT)
lamda=6328*10^(-10);k=2*pi/lamda;    %赋值波长,单位:米,波矢
f=0.004; Lo=0.001;                   %赋值透镜的焦距,物面的尺寸Lo,单位:米
xo=linspace(-Lo/2,Lo/2,r);yo=linspace(-Lo/2,Lo/2,c); %赋值物面的坐标
[xo,yo]=meshgrid(xo,yo);             %生成物面的坐标网格
do=0.0041;                         %物面到透镜的距离do,单位:米
L=r*lamda*do/Lo;                    %衍射光在透镜前表面上的尺寸L,单位:米
xl=linspace(-L/2,L/2,r);yl=linspace(-L/2,L/2,c); %赋值透镜前表面的坐标
[xl,yl]=meshgrid(xl,yl);               %生成透镜前表面的坐标网格
F0=exp(1i*k*do)/(1i*lamda*do)*exp(1i*k/2/do*(xl.^2+yl.^2));
F=exp(1i*k/2/do*(xo.^2+yo.^2));
FU=(Lo*Lo/r/r).*fftshift(fft2(Uo.*F)); 
U1=F0.*FU;                         %透镜前表面上的光场复振幅分布
I1=U1.*conj(U1);                     %透镜前表面上的光强分布
% figure,imshow(I1,[]),title('透镜前表面的光强分布')
%%
%下面计算焦平面上的频谱
Uf=fftshift(fft2(Uo));            %计算后焦面上的光场分布
If=Uf.*conj(Uf);                  %后焦面上的光强分布
figure,imshow(If,[0,max(If(:))/10000]),title('后焦面上的光强分布')
%%
%下面生成多边形滤波器
mode=2;                           %1为手动框选滤波器，2为使用预设的滤波器
H=zeros(c,r);                     %预设滤波器H
R=lamda*f/Lo*10;
if mode==1
[cc,rr]=getline(gcf,'closed');   %在图中选择多边形，并将坐标赋值给cc和rr
H=roipoly(H,cc,rr);
end
if mode==2                         %选择已经生成的滤波器
    Hnum=1;
     switch Hnum
         case 1
cc=[251,261,261,251];
rr=[0,0,512,512];
H=roipoly(H,cc,rr); 
         case 2
cc=[1,1,511,511];
rr=[251,261,261,251];
H=roipoly(H,cc,rr); 
         case 3
cc=[10,512,502,1];
rr=[1,502,512,10];
H=roipoly(H,cc,rr); 
         case 4
cc=[502,512,10,1];
rr=[1,10,512,502];
H=roipoly(H,cc,rr);
         case 5
for x=1:r
    for y=1:c
        if sqrt((x-round(r/2))^2+(y-round(c/2))^2)/512*Lo<=R
            H(x,y)=1;
        end
    end
end
         case 6
[xx,yy]=meshgrid(1:r,1:c);
D0=R/3;
D=sqrt((xx-round(r/2)).^2+(yy-round(c/2)).^2)/512*Lo;
H=exp(-D.^2./2./D0.^2);
     end
end
H=double(H);
Ufyp=H.*Uf;
figure,imshow(H,[]),title('滤波器')
figure,plot(H(round(c/2),:)),title('滤波器的切面')
IUfyp=H.*If;
figure,imshow(IUfyp,[0,max(If(:))/3000]),title('滤波后')
%%
%下面计算通过焦面后的光场到达观察面的光场
Ui=ifft2(Ufyp);
Ii=Ui.*conj(Ui);                 %滤波后像面上的光强分布
figure,imshow(Ii,[]),title('再现像'),colormap(gray)
figure,plot(Ii(round(c/2),:)),title('再现像的水平切面'),colormap(gray)
figure,plot(Ii(:,round(c/2))),title('再现像的竖直切面'),colormap(gray)