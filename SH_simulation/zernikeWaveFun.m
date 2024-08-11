function [ZerRandWave,zernikeAout] = zernikeWaveFun(size_init, N_init, zernikeGroup_init)
%%
% size_init�����ɾ���Ĵ�С
% N_init������ǰN��zernike����ʽ
% zernikeAout��������ʽ��ϵ��
% ZerRandWave�����ɵ�ǰN��zernike����ʽ��ǰ
%% ���ݳ�ʼ��
% �Թ�ͫ�Ĺ�һ������Ϊ1
c=size_init;r=c; % ���������
N=N_init; % ��������
%% ����ֲ����ο�����-��΢����
zernikeA = ones(N,1);
zernikeA(1:5,1)=2*pi;
zernikeA(6:20,1)=0.8*pi;
zernikeA(21:54,1)=0.4*pi;
zernikeA(55:119,1)=0.1*pi;
%% ����ǰN��zernike����ʽ
ZerRandRatio = unifrnd(-1,1,[N,1]);
ZerRandWave = zeros(c,r);
zernikeAout = zeros(size(zernikeA));
for stepN = 1:N
    zernikeAout(stepN)=ZerRandRatio(stepN)*zernikeA(stepN);
    ZerRandWave = ZerRandWave + zernikeGroup_init(:,:,stepN)*zernikeAout(stepN);
end
ZerRandWave(ZerRandWave==0)=nan;
zernikeAout=zernikeAout(1:N);
end