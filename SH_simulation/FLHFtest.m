clc;clear;close all;
c=540;r=c;                        %���������
lensNum=36;
pixelSize=c/lensNum;
lamda=6328*10^(-10);k=2*pi/lamda;    %��ֵ����,��λ:��,��ʸ
Lo=0.0001;                   %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
x = linspace(-1,1,r);
[X,Y]=meshgrid(x,x);
alpha=pi/2.00; %�ο����� x ���ļн�
beita=pi*0.8; %�ο����� y ���ļн�
UobPhase=(X*cos(alpha)+Y*cos(beita));
% UobPhase=X;
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %Ԥ����
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure,imshow(UobPhase,[]),title('���ֲ�')              %��ʾ��ֲ�
%%
for step=1:lensNum^2
    rNum=ceil(step/lensNum);
    cNum=step-(rNum-1)*lensNum;
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
    [I1, If] = FlhfDiff(lamda, Lo, pixelSize, ULittle);
    Ulen(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=I1;
    Uout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
% figure,imshow(Ulen,[]),title('͸��ǰ����Ĺ�ǿ�ֲ�')
figure,imshow(Uout,[0,max(If(:))/10000]),title('�����ϵĹ�ǿ�ֲ�')
%% �����ⳡ
UfWhole=fftshift(fft2(Uob));            %��������ϵĹⳡ�ֲ�
IfWhole=UfWhole.*conj(UfWhole);                  %�����ϵĹ�ǿ�ֲ�
figure,mesh(real(UfWhole)),title('�����ϵĹ�ǿ�ֲ�')
figure,mesh(IfWhole),title('�����ϵĹ�ǿ�ֲ�')
figure,imshow(real(UfWhole)),title('�����ϵĹ�ǿ�ֲ�')
figure,imshow(IfWhole),title('�����ϵĹ�ǿ�ֲ�')
figure,mesh(If),title('�����ϵĹ�ǿ�ֲ�')