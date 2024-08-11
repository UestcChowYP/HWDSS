clc;clear;close all
%% 数据初始化
% lensNum=36;
% N = 119;
% pixelSize = 15;
% rou=0;
% zernikeGroup=0;
%% 文件读取测试
% A=imread('直接再现数据集/train/train1.jpg');
load('train_UobPhase1.mat');
data = importdata('outputTest.txt');
% figure,imshow(ZerRandWave,[])
figure,mesh(data)
figure,mesh(UobPhase)
figure,mesh(data-UobPhase)
%% HartmanDiff使用测试
