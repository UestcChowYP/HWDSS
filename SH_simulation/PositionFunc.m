function [PositionX, PositionY] = PositionFunc(lensNum_init, pixelSize_init, Uout_init, cirPosXY_init, realR_init)
%% ��������λ�õ�func
% lensNum_init:S-H��΢͸������
% pixelSize_init:����΢͸����Ӧ����������
% Uout_init:������Ĺⳡ����
% cirPosXY_init:��Ч�ӿ׾�λ���б�
% realR_init:�۲���뾶
% PositionX��Xλ��
% PositionY��Yλ��
%%
[x0, ~]=size(Uout_init);
x = linspace(-1,1,x0).*realR_init;
[Xpos,Ypos] = meshgrid(x,x);
%%
PositionX=zeros(lensNum_init, lensNum_init);
PositionY=zeros(lensNum_init, lensNum_init);
for step=1:length(cirPosXY_init(:,1))
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    ULittle = Uout_init(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    XLittle = Xpos(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    YLittle = Ypos(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    sumr=YLittle.*ULittle;
    sumR=sum(sumr(:));
    sumc=XLittle.*ULittle;
    sumC=sum(sumc(:));
	sumIy=sum(ULittle(:));
 	sumIx=sum(ULittle(:));
    X=sumC/sumIx;
    Y=sumR/sumIy;
    PositionX(rNum,cNum)=X;
    PositionY(rNum,cNum)=Y;
end
end

