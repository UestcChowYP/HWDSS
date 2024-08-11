function [Iout] = HartmanDiff(r_init,cirPosXY_init,Uob,pixelSize,pixelSizeM)
%% 计算物光传递到透镜的衍射过程(S-FFT)
% lamd_init:波长
% r_init:像素点长or宽
% cirPosXY_init:有效孔径坐标
% Uob:输入的光波场
% Iout:焦平面光场
%%
Iout=zeros(r_init,r_init);
Umid=zeros(pixelSize*2,pixelSize*2);
for step=1:length(cirPosXY_init)
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    Umid(round(pixelSize/2):end-round(pixelSize/2),round(pixelSize/2):end-round(pixelSize/2)) = ULittle;
%下面计算焦平面上的频谱
Uf=fftshift(fft2(Umid.*pixelSizeM.^2));            %计算后焦面上的光场分布
If=Uf.*conj(Uf);                  %后焦面上的光强分布
Iout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If(round(pixelSize/2):end-round(pixelSize/2),round(pixelSize/2):end-round(pixelSize/2));
end