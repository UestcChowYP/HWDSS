clc;clear;close all;
r=512;c=r;                        %���������
Uo=zeros(c,r);                    %Ԥ����
d=30;a=10;                        %��դ�����ͷ��
for n=1:d:c                       %ѭ��������(��ά��դ)
   Uo(n:n+a,:)=1;
end
for m=1:d:r
   Uo (:,m:m+a)=1;
end
Uo=Uo(1:c,1:r);
% figure,imshow(Uo,[]),title('���ֲ�')              %��ʾ��ֲ�
%%
%���������⴫�ݵ�͸�����������(S-FFT)
lamda=6328*10^(-10);k=2*pi/lamda;    %��ֵ����,��λ:��,��ʸ
f=0.004; Lo=0.001;                   %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
xo=linspace(-Lo/2,Lo/2,r);yo=linspace(-Lo/2,Lo/2,c); %��ֵ���������
[xo,yo]=meshgrid(xo,yo);             %�����������������
do=0.0041;                         %���浽͸���ľ���do,��λ:��
L=r*lamda*do/Lo;                    %�������͸��ǰ�����ϵĳߴ�L,��λ:��
xl=linspace(-L/2,L/2,r);yl=linspace(-L/2,L/2,c); %��ֵ͸��ǰ���������
[xl,yl]=meshgrid(xl,yl);               %����͸��ǰ�������������
F0=exp(1i*k*do)/(1i*lamda*do)*exp(1i*k/2/do*(xl.^2+yl.^2));
F=exp(1i*k/2/do*(xo.^2+yo.^2));
FU=(Lo*Lo/r/r).*fftshift(fft2(Uo.*F)); 
U1=F0.*FU;                         %͸��ǰ�����ϵĹⳡ������ֲ�
I1=U1.*conj(U1);                     %͸��ǰ�����ϵĹ�ǿ�ֲ�
% figure,imshow(I1,[]),title('͸��ǰ����Ĺ�ǿ�ֲ�')
%%
%������㽹ƽ���ϵ�Ƶ��
Uf=fftshift(fft2(Uo));            %��������ϵĹⳡ�ֲ�
If=Uf.*conj(Uf);                  %�����ϵĹ�ǿ�ֲ�
figure,imshow(If,[0,max(If(:))/10000]),title('�����ϵĹ�ǿ�ֲ�')
%%
%�������ɶ�����˲���
mode=2;                           %1Ϊ�ֶ���ѡ�˲�����2Ϊʹ��Ԥ����˲���
H=zeros(c,r);                     %Ԥ���˲���H
R=lamda*f/Lo*10;
if mode==1
[cc,rr]=getline(gcf,'closed');   %��ͼ��ѡ�����Σ��������긳ֵ��cc��rr
H=roipoly(H,cc,rr);
end
if mode==2                         %ѡ���Ѿ����ɵ��˲���
    Hnum=1;
     switch Hnum
         case 1
cc=[251,261,261,251];
rr=[0,0,512,512];
H=roipoly(H,cc,rr); 
         case 2
cc=[1,1,511,511];
rr=[251,261,261,251];
H=roipoly(H,cc,rr); 
         case 3
cc=[10,512,502,1];
rr=[1,502,512,10];
H=roipoly(H,cc,rr); 
         case 4
cc=[502,512,10,1];
rr=[1,10,512,502];
H=roipoly(H,cc,rr);
         case 5
for x=1:r
    for y=1:c
        if sqrt((x-round(r/2))^2+(y-round(c/2))^2)/512*Lo<=R
            H(x,y)=1;
        end
    end
end
         case 6
[xx,yy]=meshgrid(1:r,1:c);
D0=R/3;
D=sqrt((xx-round(r/2)).^2+(yy-round(c/2)).^2)/512*Lo;
H=exp(-D.^2./2./D0.^2);
     end
end
H=double(H);
Ufyp=H.*Uf;
figure,imshow(H,[]),title('�˲���')
figure,plot(H(round(c/2),:)),title('�˲���������')
IUfyp=H.*If;
figure,imshow(IUfyp,[0,max(If(:))/3000]),title('�˲���')
%%
%�������ͨ�������Ĺⳡ����۲���Ĺⳡ
Ui=ifft2(Ufyp);
Ii=Ui.*conj(Ui);                 %�˲��������ϵĹ�ǿ�ֲ�
figure,imshow(Ii,[]),title('������'),colormap(gray)
figure,plot(Ii(round(c/2),:)),title('�������ˮƽ����'),colormap(gray)
figure,plot(Ii(:,round(c/2))),title('���������ֱ����'),colormap(gray)