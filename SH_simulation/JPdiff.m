clc;clear;close all;
%% ���ݳ�ʼ��
% �Թ�ͫ�Ĺ�һ������Ϊ1
lamda=6328*10^(-10);k=2*pi/lamda;                                          %��ֵ����,��λ:��,��ʸ
Lo=14.1e-3;%14.1e-3                                                         %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
c=540;r=c;                                                                  %���������
lensNum=36;
pixelSize=c/lensNum;                                                       %�ӿ׾���������              
pixelSizeM=0.02e-3;                                                      %�������ش�С0.02mm,��0.02e-3m
pixelSizeReal=2/r;                                                      %ʹ�ù�һ������
%% �ⳡ��ʼ��
x = linspace(-pixelSizeM.*r./2,pixelSizeM.*r./2,r);
[X,Y]=meshgrid(x,x);
alpha=pi/2.00; %�ο����� x ���ļн�
beita=pi*0.8; %�ο����� y ���ļн�
UobPhase=(X*cos(alpha)+Y*cos(beita));
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %Ԥ����
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure,imshow(UobPhase,[]),title('���ֲ�')              %��ʾ��ֲ�
%%
UobT=Uob.*exp(-1i.*k./2./Lo.*(X.^2+Y.^2)); %͸��������

H=exp(1i.*k.*Lo./(1i./lamda./Lo)).*exp(1i.*k./2./Lo.*(X.^2+Y.^2)); %���ݺ���
Uout=fftshift(ifft2(fft2(UobT).*fft2(H).*pixelSizeM.^4).*(1./(r.*pixelSizeM)).^2.*r.^2);
figure,imshow(H)