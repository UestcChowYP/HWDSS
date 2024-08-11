function [zernikeGradNo0] = WavefrontGrad(lensNum_init,N_init,rou_init,zernikeGroup_init,pixelSizeM_init,cirPosXY_init)
%% 数据初始化
% lensNum_init:微透镜的数量;
% N_init：zernike多项式数量119;
% pixelSize_init:15;
% rou=0;
% zernikeGroup=0;
%% 计算x, y方向上的平均斜率
r_init=size(rou_init,1);
pixelSize_init=r_init/lensNum_init;
zernikeGrad = zeros(2 * length(cirPosXY_init), N_init);
for i=1:N_init
    zernikeNow = zernikeGroup_init(:,:,i);
for step=1:length(cirPosXY_init)
    rNum=cirPosXY_init(step,1);
    cNum=cirPosXY_init(step,2);
    zernikeNowS = zernikeNow(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    rouS = rou_init(rNum*pixelSize_init-pixelSize_init+1:rNum*pixelSize_init, cNum*pixelSize_init-pixelSize_init+1:cNum*pixelSize_init);
    if max(rouS(:))<=1&&min(rouS(:))>0
        [zernikeNowX, zernikeNowY] = gradient(zernikeNowS, pixelSizeM_init, pixelSizeM_init); % 梯度计算
        zernikeGrad(2*step-1,i)=sum(zernikeNowX(:))./length(zernikeNowX(:));
        zernikeGrad(2*step,i)=sum(zernikeNowY(:))./length(zernikeNowY(:));
    end
end
end
zernikeGradNo0=zernikeGrad;
% zernikeGradNo0(all(zernikeGrad==0,2),:) = [];
end