clc;clear;close all;
%% ���ݳ�ʼ��
% �Թ�ͫ�Ĺ�һ������Ϊ1
c=540;r=c; % ���������
N=120; % ��������
% %% ����ֲ����ο�����-��΢����
% zernikeA = ones(N,1);
% zernikeA(1:2,1)=4*pi;
% zernikeA(3,1)=0.4*pi;
% zernikeA(4:5,1)=3*pi;
% zernikeA(6,1)=pi;
% zernikeA(7,1)=1.6*pi;
% zernikeA(8,1)=4*pi;
% zernikeA(9,1)=2.8*pi;
% zernikeA(10,1)=1.2*pi;
% zernikeA(11,1)=0.4*pi;
% zernikeA(12,1)=2.4*pi;
% zernikeA(13,1)=0.6*pi;
% zernikeA(14,1)=2.6*pi;
% zernikeA(15,1)=1.6*pi;
% zernikeA(16:17,1)=0.8*pi;
% zernikeA(18:21,1)=1.2*pi;
% zernikeA(22,1)=0.4*pi;
% zernikeA(23,1)=0.2*pi;
% zernikeA(24,1)=0.8*pi;
% zernikeA(25,1)=0.6*pi;
% zernikeA(26,1)=0.4*pi;
% zernikeA(27,1)=3.2*pi;
% zernikeA(28,1)=0.6*pi;
% zernikeA(29,1)=0.2*pi;
% zernikeA(30:31,1)=0.4*pi;
% zernikeA(32,1)=0.8*pi;
% zernikeA(33,1)=0.4*pi;
% zernikeA(32:36,1)=0.8*pi;
% zernikeA(37:45,1)=0.4*pi;
% zernikeA(46:52,1)=0.2*pi;
% zernikeA(53,1)=0.5*pi;
% zernikeA(54,1)=1.2*pi;
% zernikeA(55:119,1)=0.2*pi;
% %% ����ǰN��zernike����ʽ
% [zernikeGroup,theta,rou] = zernikeN(r, N);
% ZerRandRatio = unifrnd(-1,1,[N,1]);
% ZerRandWave = zeros(c,r);
% zernikeAout = zeros(size(zernikeA));
% for stepN = 1:N
%     zernikeAout(stepN)=ZerRandRatio(stepN)*zernikeA(stepN);
%     ZerRandWave = ZerRandWave + zernikeGroup(:,:,stepN)*zernikeAout(stepN);
% end
% ZerRandWave(ZerRandWave==0)=nan;
% figure,mesh(ZerRandWave),title('���ɵ������ǰ')
%% ��������
[ZerRandWave,zernikeAout] = zernikeWaveFun(r, N);
ZerRandWave(ZerRandWave==0)=nan;
figure,mesh(ZerRandWave),title('���ɵ������ǰ')