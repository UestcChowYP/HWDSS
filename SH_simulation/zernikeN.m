function [zernikeGroup] = zernikeN(rou_init,theta_init,N_init)
%% 参数说明
% rou_init：归一化坐标rou
% theta_init：归一化坐标theta
% N_init：生成的zernike项数
% zernikeGroup：生成的zernike多项式
%% 初始化
idx = rou_init<=1;
[sizeX,sizeY] = size(theta_init);
zernikeGroup = zeros(sizeX,sizeY,N_init);
zernikeGroupMid = zeros(sizeX,sizeY);
step=1;
for step1 = 1:N_init
    for step2 = step1:-2:-step1
        zernikeGroupMid(idx) = zernfun(step1,step2,rou_init(idx),theta_init(idx));
        zernikeGroup(:,:,step) = zernikeGroupMid;
        step = step+1;
        if step>N_init
                break
        end
    end
    if step>N_init
        break
    end
end

end