clc;clear;close all;
c=15;r=c;                        %���������
lensNum=36;
pixelSize=c/lensNum;
lamda=6328*10^(-10);k=2*pi/lamda;    %��ֵ����,��λ:��,��ʸ
Lo=14.1e-3;                   %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
x = linspace(-1,1,r);
[X,Y]=meshgrid(x,x);
%%
alpha=pi/2.00; %�ο����� x ���ļн�
beita=pi*0.53; %�ο����� y ���ļн�
UobPhase=(X*cos(alpha)+Y*cos(beita));
figure,mesh(UobPhase)
%%
Uob=ones(r,c).*exp(1i.*k.*UobPhase);                    %Ԥ����
Ulen=zeros(r,c);
Uout=zeros(r,c);
figure(1),mesh(UobPhase),title('���ֲ�')              %��ʾ��ֲ�
%% �����ⳡ
UfWhole=fftshift(fft2(Uob));            %��������ϵĹⳡ�ֲ�
IfWhole=UfWhole.*conj(UfWhole);                  %�����ϵĹ�ǿ�ֲ�
% figure,mesh(real(UfWhole)),title('�����ϵĹ�ǿ�ֲ�')
figure(2),mesh(IfWhole),title('�����ϵĹ�ǿ�ֲ�')
figure(3),imshow(IfWhole/max(IfWhole(:)), [0,1/1e3]),title('�����ϵĹ�ǿ�ֲ�')
A = k.*UobPhase;
figure,mesh(A)