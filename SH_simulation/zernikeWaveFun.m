function [ZerRandWave,zernikeAout] = zernikeWaveFun(size_init, N_init, zernikeGroup_init)
%%
% size_init：生成矩阵的大小
% N_init：生成前N项zernike多项式
% zernikeAout：各多项式的系数
% ZerRandWave：生成的前N项zernike多项式波前
%% 数据初始化
% 以光瞳的归一化长度为1
c=size_init;r=c; % 物面采样数
N=N_init; % 生成项数
%% 先验分布（参考论文-显微成像）
zernikeA = ones(N,1);
zernikeA(1:5,1)=2*pi;
zernikeA(6:20,1)=0.8*pi;
zernikeA(21:54,1)=0.4*pi;
zernikeA(55:119,1)=0.1*pi;
%% 生成前N项zernike多项式
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