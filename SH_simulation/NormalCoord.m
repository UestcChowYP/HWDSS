function [theta,rou,idxIn,idxOut,cirPos,cirPosXY] = NormalCoord(size_init,lensNum_init)
%% 参数说明
% size_init:生成归一化矩阵的采样点数量
% lensNum_init：子孔径
% theta：极坐标theta
% rou：极坐标rou
% idx：系统孔径内的位置坐标
% cirPos：系统孔径内的微透镜
% cirPosXY：系统孔径内的微透镜位置坐标
%% 单位元内有效坐标
pixelSize_init=size_init/lensNum_init;
x = linspace(-1,1,size_init);
[X,Y] = meshgrid(x,x);
[theta,rou] = cart2pol(X,Y);
idxIn = rou<=1;
idxOut = rou>=1;
%% 子孔径阵列的有效孔径
cirPos = zeros(lensNum_init, lensNum_init); % 记录有效微透镜矩阵的位置以及坐标
cirPosX = zeros(lensNum_init, lensNum_init);
cirPosY = zeros(lensNum_init, lensNum_init);
cirPosXY = zeros(lensNum_init.^2, 2);
for step=1:lensNum_init ^ 2
    rNum=ceil(step / lensNum_init);
    cNum=step - (rNum-1) * lensNum_init;
    rouS = rou(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    if max(rouS(:))<=1&&min(rouS(:))>0
        cirPos(rNum, cNum) = 1;
        cirPosX(rNum, cNum) = cNum;
        cirPosY(rNum, cNum) = rNum;
    end
end
cirPosXY(:, 1) = cirPosX(:);
cirPosXY(:, 2) = cirPosY(:);
cirPosXY(all(cirPosXY==0,2),:) = [];
end