clc;clear;close all;
c=540;r=c;                                                                  %���������
lensNum=36;
pixelSize=c/lensNum;                                                        
pixelSizeReal=0.02e-3;                                                      %�������ش�С0.02mm,��0.02e-3m
UobOrigin=ones(r,c);
UobPhase=0.005*peaks(r);
Uob=UobOrigin.*exp(1i.*UobPhase);                                           %Ԥ����
Uob=Uob(1:r,1:c);
Ulen=zeros(r,c);
Uout=zeros(r,c);
% figure,imshow(Uob,[]),title('���ֲ�')                                     %��ʾ��ֲ�
%% ����SH̽����
lamda=6328*10^(-10);k=2*pi/lamda;                                          %��ֵ����,��λ:��,��ʸ
Lo=12.1e-3;                                                                 %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
% ԭʼλ��
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = UobOrigin(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    UoutOri(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
% ���������λ��
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    Uout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
%% ����ǰ�������λ��
[PositionXOri, PositionYOri] = PositionFunc(lensNum, pixelSize, UoutOri);
[PositionX, PositionY] = PositionFunc(lensNum, pixelSize, Uout);
%% ���㲨ǰб��
gradientX=(PositionX-PositionXOri)/Lo*pixelSizeReal;
gradientY=(PositionY-PositionYOri)/Lo*pixelSizeReal;
