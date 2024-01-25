% 参考文献：SCALABLE DISTRIBUTED OPTIMIZATION OF MULTI-DIMENSIONAL FUNCTIONS DESPITE BYZANTINE ADVERSARIES
% 作者：李云龙
% 时间：2023.11.11
clc;
clear all;

%% 1.初始化节点状态 (i,j,k) 表示第k个节点 j时刻 第i个维度的值
% 分别记录6个常规节点在不同时刻下的演化曲线
x(:,1,1) = [-1 1]';
x(:,1,2) = [-2 2]';
x(:,1,3) = [-3 3]';
x(:,1,4) = [-4 4]';
x(:,1,5) = [-5 5]';
x(:,1,6) = [-6 6]';
x(:,1,7) = [-7 7]';
x(:,1,8) = [-8 8]';
x(:,1,9) = [-9 9]';
x(:,1,10) = [-10 10]';
x(:,1,11) = [-11 11]';
x(:,1,12) = [-12 12]';
x(:,1,13) = [-13 13]';
x(:,1,14) = [-14 14]';
x(:,1,15) = [-15 15]';


%% 2.描述图的拓扑结构
% e.g 全连接矩阵
[d,~,n] = size(x);
% 邻接矩阵，只需要根据图拓扑修改A即可
A = AdjacencyMatrix(n);
% 度矩阵D 
D = diag(sum(A,2)); 
% 拉普拉斯矩阵 
L = D - A; 
% 行随机权重矩阵，满足行和为1即可，参照Nedic 2009 TAC 
W = Weight(L); 


%% 3.获得每个节点的邻居序号
% 邻居矩阵，设定元胞数组，共有n个节点
neighbors = cell(1,n);

for i = 1:n
    xtemp(:,i) = x(:,1,i);      % 中间变量，记录第k时刻，所有结点的状态
    xsyn(:,i) = x(:,1,i);       % 中间变量，记录第k+1时刻，所有节点同步更新后的状态

    neighbors{1,i} = select_neighbor(L(i,:));
end

%% 4.仿真迭代
T = 1000;                 % 设置迭代次数
stepC = 4;                % 设置迭代倍数
k0 = 5;
alpha = 0.98;

for k = 1:T
    
    % 迭代步长 衰减的
    stepK = stepC/(k+k0)^alpha ;  

    for i = 1:n                           % 并行计算，每个结点分别同时计算
        ytemp = W(i,:) * xtemp';          % 加权
        ytemp = ytemp';
        xsyn(:,i) = ytemp - stepK * grad(i,ytemp);      % 节点i下一步到达的状态
    end

    % 读取状态
    for i = 1:n
        xtemp(:,i) = xsyn(:,i);
        x(:,k+1,i) = xsyn(:,i);
    end

end

%% 5.计算真实值
% 定义目标函数
fun_i = @(i, x) (x(1) + i)^2 + (x(2) - i)^2;
% 定义目标函数，即所有节点函数的和
fun_sum = @(x) sum(arrayfun(@(i) fun_i(i, x), [Regularnodes]));
% 初始猜测值
x0 = zeros(2,1);
% 求解无约束最小化问题，即求解和函数真实最优解
options = optimset('Display', 'iter'); % 设置显示迭代过程
[x_min, fval] = fminunc(fun_sum, x0, options);
% 输出
disp(x_min)
disp(['极小值 f(x): ', num2str(fval)])

%% 6.一致性分析
% 第m维 一致性收敛曲线
figure
% 设置每行显示的图例个数
r = 4;

for k = 1:d
    subplot(d, 1, k)
    % 使用 for 循环遍历向量
    for i = 1:length(Regularnodes)
        plot(1:T, x(k, 1:T, Regularnodes(i)), '-.', 'linewidth', 1.5, 'DisplayName', ['Agent ', num2str(Regularnodes(i))]);
        hold on;
    end
    plot(1:T, ones(size(1:T)) * x_min(k), 'k.-', 'linewidth', 2, 'DisplayName', ['min value']);
    hold on;
    title(['Variable ', num2str(k), ' Trajectories']);
    xlabel('Time');
    ylabel(['Variable ', num2str(k)]);
    % 显示图例
    hLegend = legend('show');
    % 去除图例的边框
    set(hLegend, 'Box', 'off');
    % 调整图例的位置和布局
    legend('NumColumns', r, 'Location', 'best');
end

