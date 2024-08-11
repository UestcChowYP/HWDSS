function [Iout] = FNRdiff(r_init,cirPosXY_init,Uob,pixelSize,pixelSizeM_init,Lo,lamda)
%% ��ʼ������
% lamda=6328*10^(-10);
k=2*pi/lamda;                                          %��ֵ����,��λ:��,��ʸ
c=15;r=c;                                                                  %���������         
pixelSizeM=pixelSizeM_init;                                                      %�������ش�С0.02mm,��0.02e-3m
%%
x=linspace(-pixelSizeM.*c./2,pixelSizeM.*c./2,c);            %����Ƶ������ 
y=linspace(-pixelSizeM.*r./2,pixelSizeM.*r./2,r);
[x,y]=meshgrid(x,y);                            %Ƶ��Ķ�ά����
L0=pixelSizeM.*r;                                   %����������ĳߴ�,��λ:��
u=linspace(-1./2./L0,1./2./L0,c).*c;            %����Ƶ������ 
v=linspace(-1./2./L0,1./2./L0,r).*r;
[u,v]=meshgrid(u,v);  
H=exp(1i*k*Lo.*(1-lamda.*lamda.*(u.*u+v.*v)./2)); %���ݺ���

Iout=zeros(r_init,r_init);
Umid=zeros(pixelSize,pixelSize);
for step=1:length(cirPosXY_init)
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    ULittle = Uob(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize);
%������㽹ƽ���ϵ�Ƶ��
UobT=ULittle.*exp(-1i.*k./2./Lo.*(x.^2+y.^2));
fa=fftshift(fft2(UobT));                          %����׵�Ƶ�� 
Fuf=fa.*H;                                      %�˲�
U=ifft2(Fuf);                                   %�ڹ۲����ϵĹⳡ�ֲ�
If=U.*conj(U);                                   %�ڹ۲����ϵĹ�ǿ�ֲ�
Iout(rNum*pixelSize-pixelSize+1:rNum*pixelSize, cNum*pixelSize-pixelSize+1:cNum*pixelSize)=If;
end
end