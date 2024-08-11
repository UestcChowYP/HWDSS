clc;clear;close all;
c=512;r=c;                        %���������
Uo=zeros(r,c);                    %Ԥ����
d=30;a=10;                        %��դ�����ͷ��
for n=1:d:r                       %ѭ��������(��ά��դ)
   Uo(n:n+a,:)=1;
end
for m=1:d:c
   Uo (:,m:m+a)=1;
end
Uo=Uo(1:r,1:c);
figure,imshow(Uo,[]),title('���ֲ�')              %��ʾ��ֲ�
%%
%���������⴫�ݵ�͸�����������(S-FFT)
lamda=6328*10^(-10);k=2*pi/lamda;    %��ֵ����,��λ:��,��ʸ
Lo=0.0001;                   %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
xo=linspace(-Lo/2,Lo/2,c);yo=linspace(-Lo/2,Lo/2,r);  %��ֵ���������
[xo,yo]=meshgrid(xo,yo);             %�����������������
do=0.00041;                         %���浽͸���ľ���do,��λ:��
L=c*lamda*do/Lo;                    %�������͸��ǰ�����ϵĳߴ�L,��λ:��
xl=linspace(-L/2,L/2,c);yl=linspace(-L/2,L/2,r); %��ֵ͸��ǰ���������
[xl,yl]=meshgrid(xl,yl);               %����͸��ǰ�������������
F0=exp(1i*k*do)/(1i*lamda*do)*exp(1i*k/2/do*(xl.^2+yl.^2));
F=exp(1i*k/2/do*(xo.^2+yo.^2));
FU=(Lo*Lo/c/c).*fftshift(fft2(Uo.*F)); 
U1=F0.*FU;                         %͸��ǰ�����ϵĹⳡ������ֲ�
I1=U1.*conj(U1);                     %͸��ǰ�����ϵĹ�ǿ�ֲ�
figure,imshow(I1,[]),title('͸��ǰ����Ĺ�ǿ�ֲ�')
%%
%������㽹ƽ���ϵ�Ƶ��
Uf=fftshift(fft2(Uo));            %��������ϵĹⳡ�ֲ�
If=Uf.*conj(Uf);                  %�����ϵĹ�ǿ�ֲ�
figure,imshow(If,[0,max(If(:))/10000]),title('�����ϵĹ�ǿ�ֲ�')
