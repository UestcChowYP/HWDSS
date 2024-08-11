function [theta,rou,idxIn,idxOut,cirPos,cirPosXY] = NormalCoord(size_init,lensNum_init)
%% ����˵��
% size_init:���ɹ�һ������Ĳ���������
% lensNum_init���ӿ׾�
% theta��������theta
% rou��������rou
% idx��ϵͳ�׾��ڵ�λ������
% cirPos��ϵͳ�׾��ڵ�΢͸��
% cirPosXY��ϵͳ�׾��ڵ�΢͸��λ������
%% ��λԪ����Ч����
pixelSize_init=size_init/lensNum_init;
x = linspace(-1,1,size_init);
[X,Y] = meshgrid(x,x);
[theta,rou] = cart2pol(X,Y);
idxIn = rou<=1;
idxOut = rou>=1;
%% �ӿ׾����е���Ч�׾�
cirPos = zeros(lensNum_init, lensNum_init); % ��¼��Ч΢͸�������λ���Լ�����
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