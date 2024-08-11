function [Iout] = HartmanDiff(r_init,cirPosXY_init,Uob,pixelSize,pixelSizeM)
%% ������⴫�ݵ�͸�����������(S-FFT)
% lamd_init:����
% r_init:���ص㳤or��
% cirPosXY_init:��Ч�׾�����
% Uob:����ĹⲨ��
% Iout:��ƽ��ⳡ
%%
Iout=zeros(r_init,r_init);
Umid=zeros(pixelSize*2,pixelSize*2);
for step=1:length(cirPosXY_init)
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    Umid(round(pixelSize/2):end-round(pixelSize/2),round(pixelSize/2):end-round(pixelSize/2)) = ULittle;
%������㽹ƽ���ϵ�Ƶ��
Uf=fftshift(fft2(Umid.*pixelSizeM.^2));            %��������ϵĹⳡ�ֲ�
If=Uf.*conj(Uf);                  %�����ϵĹ�ǿ�ֲ�
Iout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If(round(pixelSize/2):end-round(pixelSize/2),round(pixelSize/2):end-round(pixelSize/2));
end