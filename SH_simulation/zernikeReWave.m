%% ��������ǰ̽�⣬ģʽ������
clc;clear;close all;
%% ���ݳ�ʼ��
% �Թ�ͫ�Ĺ�һ������Ϊ1
lamda=6328*10^(-10);k=2*pi/lamda;                                          %��ֵ����,��λ:��,��ʸ
Lo=14.1e-3;                                                                 %��ֵ͸���Ľ���,����ĳߴ�Lo,��λ:��
c=540;r=c;                                                                  %���������
lensNum=36;
pixelSize=c/lensNum;                                                       %�ӿ׾���������              
pixelSizeM=0.02e-3;                                                      %�������ش�С0.02mm,��0.02e-3m
pixelSizeReal=2/r;                                                      %ʹ�ù�һ������
%% ����ǰN��zernike����ʽ
N = 119;
[theta,rou,idxIn_normal,idxOut_normal,cirPos,cirPosXY] = NormalCoord(r,lensNum); % ���ɹ�һ����ⳡ���꣬�׾���Чλ�ü�����
[zernikeGroup] = zernikeN(rou,theta,N); % ����ǰN��zernike����ʽ����
%% �ؽ���ǰ
idxOut = rou>1;
ZernikeARea = importdata('output9.txt');
WaveFunRe = zeros(size(theta));
for idxi = 1:N
    WaveFunRe = WaveFunRe + zernikeGroup(:,:,idxi).*ZernikeARea(idxi);
end
WaveFunRe(idxOut)=nan;
figure,mesh(WaveFunRe),title('�ؽ�����λ�ֲ�') 
figure,plot(ZernikeARea),title('�ؽ���ϵ��')
%% ԭ���Ĳ�ǰ
ZernikeAOri = importdata('���ݼ�/ѵ����target/ZernikeA_train1.xlsx', 'ReadVariableNames', false);
ZernikeAOri = ZernikeAOri(1,:);
WaveFunOri= zeros(size(theta));
for idxi = 1:N
    WaveFunOri = WaveFunOri + zernikeGroup(:,:,idxi).*ZernikeAOri(idxi);
end
WaveFunOri(idxOut)=nan;
figure,mesh(WaveFunOri),title('ԭ������λ�ֲ�') 
figure,plot(ZernikeAOri),title('ԭʼ��ϵ��')