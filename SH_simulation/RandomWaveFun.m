function [RandWave] = RandomWaveFun(initSize_init,OutSize_init)
% clc;clear;close all;
initMatrix = rand(initSize_init,initSize_init);
initMatrix = uint8(initMatrix.*255);
RandWave = imresize(initMatrix,[OutSize_init,OutSize_init]);
% figure,mesh(RandWave)
RandWave = double(RandWave);
RandWave = (RandWave-min(RandWave(:)))./(max(RandWave(:))-min(RandWave(:)));
RandWave = RandWave.*2.*pi;
end