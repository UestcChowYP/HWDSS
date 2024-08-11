clc;clear;close all;
c=540;r=c;                                                                  %物面采样数
lensNum=36;
pixelSize=c/lensNum;                                                        
pixelSizeReal=0.02e-3;                                                      %单个像素大小0.02mm,即0.02e-3m
UobOrigin=ones(r,c);
UobPhase=0.005*peaks(r);
Uob=UobOrigin.*exp(1i.*UobPhase);                                           %预设物
Uob=Uob(1:r,1:c);
Ulen=zeros(r,c);
Uout=zeros(r,c);
% figure,imshow(Uob,[]),title('物光分布')                                     %显示物分布
%% 计算SH探测结果
lamda=6328*10^(-10);k=2*pi/lamda;                                          %赋值波长,单位:米,波矢
Lo=12.1e-3;                                                                 %赋值透镜的焦距,物面的尺寸Lo,单位:米
% 原始位置
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = UobOrigin(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    UoutOri(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
% 引入像差后的位置
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    Uout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
%% 计算前后的质心位置
[PositionXOri, PositionYOri] = PositionFunc(lensNum, pixelSize, UoutOri);
[PositionX, PositionY] = PositionFunc(lensNum, pixelSize, Uout);
%% 计算波前斜率
gradientX=(PositionX-PositionXOri)/Lo*pixelSizeReal;
gradientY=(PositionY-PositionYOri)/Lo*pixelSizeReal;
