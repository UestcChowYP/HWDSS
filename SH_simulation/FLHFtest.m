clc;clear;close all;
c=540;r=c;                        %物面采样数
lensNum=36;
pixelSize=c/lensNum;
lamda=6328*10^(-10);k=2*pi/lamda;    %赋值波长,单位:米,波矢
Lo=0.0001;                   %赋值透镜的焦距,物面的尺寸Lo,单位:米
x = linspace(-1,1,r);
[X,Y]=meshgrid(x,x);
alpha=pi/2.00; %参考光与 x 轴间的夹角
beita=pi*0.8; %参考光与 y 轴间的夹角
UobPhase=(X*cos(alpha)+Y*cos(beita));
% UobPhase=X;
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %预设物
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure,imshow(UobPhase,[]),title('物光分布')              %显示物分布
%%
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    Uout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
% figure,imshow(Ulen,[]),title('透镜前表面的光强分布')
figure,imshow(Uout,[0,max(If(:))/10000]),title('后焦面上的光强分布')
%% 整个光场
UfWhole=fftshift(fft2(Uob));            %计算后焦面上的光场分布
IfWhole=UfWhole.*conj(UfWhole);                  %后焦面上的光强分布
figure,mesh(real(UfWhole)),title('后焦面上的光强分布')
figure,mesh(IfWhole),title('后焦面上的光强分布')
figure,imshow(real(UfWhole)),title('后焦面上的光强分布')
figure,imshow(IfWhole),title('后焦面上的光强分布')
figure,mesh(If),title('后焦面上的光强分布')