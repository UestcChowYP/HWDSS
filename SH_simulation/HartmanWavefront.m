%% ��������ǰ̽�⣬ģʽ������
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
%% ����ǰN��zernike����ʽ
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % ���ɹ�һ����ⳡ���꣬�׾���Чλ�ü�����
[zernikeGroup] = zernikeN(rou,theta,N); % ����ǰN��zernike����ʽ����
%% ����zernike����ʽ�Ĳ�ǰб��
[zernikeGradNo0] = WavefrontGrad(lensNum,N,rou,zernikeGroup,pixelSizeM,cirPosXY);
%% α�����
zernikeGradT = pinv(zernikeGradNo0);
%% ������ɲ�ǰ��λ
[ZerRandWave,zernikeAout] = zernikeWaveFun(r, 15, zernikeGroup);
% ZerRandWaveGradient=gradient(ZerRandWave, pixelSizeM, pixelSizeM);
% figure,mesh(ZerRandWaveGradient),title('��ǰб�ʷֲ�')
%% ��ʼ������ⳡ
UobOrigin=ones(r,c);
% UobPhase=zernikeGroup(:,:,11);
% UobPhase=peaks(r);
% UobPhase=RandomWaveFun(6,c);
UobPhase=ZerRandWave;
% UobPhase(UobPhase==0)=nan;
Uob=UobOrigin.*exp(1i.*UobPhase);                                           %Ԥ����
IlenOri=zeros(r,c);
Ilen=zeros(r,c);
figure,mesh(UobPhase),title('������λ�ֲ�')                                     %��ʾ��ֲ�
%% ����SH̽����
% ԭʼλ��
IoutOri = HartmanDiff(r,cirPosXY,UobOrigin,pixelSize,pixelSizeM);
% ���������λ��
Iout = HartmanDiff(r,cirPosXY,Uob,pixelSize,pixelSizeM);
% Iout = FNRdiff(r,cirPosXY,Uob,pixelSize,pixelSizeM,Lo,lamda);
IimR = (Iout-min(Iout(:)))./(max(Iout(:))-min(Iout(:))).*255;
IoutEq = histeq(uint8(IimR));
figure,mesh(Iout),title('SH���Ĺⳡ')
figure,imshow(Iout,[]),title('SH���Ĺⳡ')
% ����ǰ�������λ��
[PositionXOri, PositionYOri] = PositionFunc(lensNum, pixelSize, IoutOri, cirPosXY, pixelSizeM.*r/2);
[PositionX, PositionY] = PositionFunc(lensNum, pixelSize, Iout, cirPosXY, pixelSizeM.*r/2);
% ���㲨ǰб��
indexPos = cirPos~=0;
PositionXOriT=PositionXOri';
PositionYOriT=PositionYOri';
PositionXT = PositionX';
PositionYT = PositionY';
gradientDeltaX = PositionXT(indexPos)-PositionXOriT(indexPos);
gradientDeltaY = PositionYT(indexPos)-PositionYOriT(indexPos);
gradientX=gradientDeltaX./Lo./lamda.*2.*pi;
gradientY=gradientDeltaY./Lo./lamda.*2.*pi;%2.*Lo./540./pixelSizeM....Lo./(lamda.*Lo./pixelSizeM./c)
gradientXList = gradientX(:);
gradientYList = gradientY(:);
gradientList = zeros(length(gradientXList)*2, 1);
for idx = 1:length(gradientXList)
    gradientList(idx*2-1,1)=gradientXList(idx);
    gradientList(idx*2,1)=gradientYList(idx);
end
%% nernike�ֽ�ϵ������
zernikeRatio = zernikeGradT*gradientList;
figure,plot(gradientList),title('����Ĳ�ǰб��')
zernikeRe=zeros(size(rou));
for i=1:N
    zernikeRe = zernikeRe + zernikeRatio(i).*zernikeGroup(:,:,i);
end
% zernikeRe = (zernikeRe-min(zernikeRe(:)))./(max(zernikeRe(:))-min(zernikeRe(:)));
zernikeRe(idxOut_normal)=nan;
% figure,mesh(zernikeRe./max(zernikeRe(:))),title('���ֽ��')
figure,mesh(zernikeRe),title('���ֽ��')
figure,plot(zernikeAout),title('����zernikeϵ��')
figure,plot(zernikeRatio),title('����zernikeϵ��')
UobPhase_out = UobPhase.*double(idxIn_normal);
% save(['UobPhase_test',num2str(N),'.mat'],'UobPhase_out');
% imwrite(Iout./(max(Iout(:))),'test.jpg');