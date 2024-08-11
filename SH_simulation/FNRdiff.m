function [Iout] = FNRdiff(r_init,cirPosXY_init,Uob,pixelSize,pixelSizeM_init,Lo,lamda)
%% 初始化参数
% lamda=6328*10^(-10);
k=2*pi/lamda;                                          %赋值波长,单位:米,波矢
c=15;r=c;                                                                  %物面采样数         
pixelSizeM=pixelSizeM_init;                                                      %单个像素大小0.02mm,即0.02e-3m
%%
x=linspace(-pixelSizeM.*c./2,pixelSizeM.*c./2,c);            %给出频域坐标 
y=linspace(-pixelSizeM.*r./2,pixelSizeM.*r./2,r);
[x,y]=meshgrid(x,y);                            %频域的二维网格
L0=pixelSizeM.*r;                                   %给出衍射面的尺寸,单位:米
u=linspace(-1./2./L0,1./2./L0,c).*c;            %给出频域坐标 
v=linspace(-1./2./L0,1./2./L0,r).*r;
[u,v]=meshgrid(u,v);  
H=exp(1i*k*Lo.*(1-lamda.*lamda.*(u.*u+v.*v)./2)); %传递函数

Iout=zeros(r_init,r_init);
Umid=zeros(pixelSize,pixelSize);
for step=1:length(cirPosXY_init)
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
%下面计算焦平面上的频谱
UobT=ULittle.*exp(-1i.*k./2./Lo.*(x.^2+y.^2));
fa=fftshift(fft2(UobT));                          %衍射孔的频谱 
Fuf=fa.*H;                                      %滤波
U=ifft2(Fuf);                                   %在观察屏上的光场分布
If=U.*conj(U);                                   %在观察屏上的光强分布
Iout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
end