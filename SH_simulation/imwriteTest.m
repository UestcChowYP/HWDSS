clc;clear;close all;
lamda=6328*10^(-10);k=2*pi/lamda;                                          %��ֵ����,��λ:��,��ʸ
Lo=14.1e-3;                                                                 %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
c=240;r=c;                                                                  %���������
lensNum=16;
pixelSize=c/lensNum;                                                        
pixelSizeM=0.04e-3;                                                      %�������ش�С0.02mm,��0.02e-3m
pixelSizeReal=2/r;                                                      %ʹ�ù�һ������
N = 119;
zerNum=119;
zernikeAoutAll=zeros(N,zerNum);
%% ����Zernike��ǰ
% circ = 1;
%% ����ǰN��zernike����ʽ
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % ���ɹ�һ����ⳡ���꣬�׾���Чλ�ü�����
[zernikeGroup] = zernikeN(rou,theta,N); % ����ǰN��zernike����ʽ����
%% 
for circ = 20481:40960
%% ������ɲ�ǰ��λ
[ZerRandWave1,zernikeAout] = zernikeWaveFun(r, N, zernikeGroup);
initSize = round(rand.*8)+2;
[ZerRandWave2] = RandomWaveFun(initSize,r);
ZerRandWave = (ZerRandWave1+ZerRandWave2)/2;
% ZerRandWave = ZerRandWave2;
% figure,mesh(ZerRandWave),title('������λ')
%% ��������
ZerRandWaveOne = (ZerRandWave-min(ZerRandWave(:)))./(max(ZerRandWave(:))-min(ZerRandWave(:))); % ��һ��
% ZerRandWaveUint = uint8(ZerRandWaveOne);
Aratio=rand().*0.0004;
Bratio=rand().*0.0002;
ZerRandWaveNoise=imnoise(ZerRandWaveOne,'gaussian',Aratio,Bratio); % ��ֵ/����
ZerRandWaveNoise=ZerRandWaveNoise.*(max(ZerRandWave(:))-min(ZerRandWave(:)))+min(ZerRandWave(:));
ZerRandWaveNoise(idxOut_normal)=0;
% figure,mesh(ZerRandWaveNoise()),title('������λ') 
%% ��ʼ������ⳡ
UobOrigin=ones(r,c);
UobPhase=double(ZerRandWaveNoise);
UobPhase(idxOut_normal)=nan;                                        %Ԥ����
Uob=UobOrigin.*exp(1i.*UobPhase);
% figure,mesh(UobPhase),title('������λ�ֲ�')                                     %��ʾ��ֲ�
%% ����SH̽����
Iout = HartmanDiff(r,cirPosXY,Uob,pixelSize,pixelSizeM);
IimR = (Iout-min(Iout(:)))./(max(Iout(:))-min(Iout(:)));
IimRImp = zeros(256,256);
IimRImp(9:end-8,9:end-8)=IimR;
IimR=IimRImp;
% figure,imshow(IimR,[]),title('SH���Ĺⳡ')
%% �������ɵ��ļ�
UobPhase(idxOut_normal)=0;
UobPhaseImp = zeros(256,256);
UobPhaseImp(9:end-8,9:end-8)=UobPhase;
UobPhase=UobPhaseImp;
% figure,mesh(UobPhase),title('������λ�ֲ�') 
save(['ֱ���������ݼ�/trainTest_target/train_UobPhase',num2str(circ),'.mat'],'UobPhase');
save(['ֱ���������ݼ�/trainTest/train_Hart',num2str(circ),'.mat'],'IimR');
% imwrite(Iout./(max(Iout(:))),['ֱ���������ݼ�/train/train',num2str(circ),'.jpg']);
end
