clc;clear;close all
%% ���ݳ�ʼ��
% lensNum=36;
% N = 119;
% pixelSize = 15;
% rou=0;
% zernikeGroup=0;
%% �ļ���ȡ����
% A=imread('ֱ���������ݼ�/train/train1.jpg');
load('train_UobPhase1.mat');
data = importdata('outputTest.txt');
% figure,imshow(ZerRandWave,[])
figure,mesh(data)
figure,mesh(UobPhase)
figure,mesh(data-UobPhase)
%% HartmanDiffʹ�ò���
