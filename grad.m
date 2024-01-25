function gradient_vector = grad(i,input_vector)

%   % 定义符号变量和符号表达式
%   syms x1 x2;                      % 二维向量       (说明：几维向量就设几个变量)
%   f = (x1 + i)^2 + (x2 - i)^2;     % 实际函数表达式 (说明：按需更改)
%   % 计算梯度
%   gradient_sym = gradient(f, [x1, x2]); 
%   % 将符号表达式转换为函数表达式
%   gradient_vector = matlabFunction(gradient_sym, 'Vars', {x1, x2}); 
%   % 计算梯度的值
%   gradient_vector = gradient_vector(input_vector(1), input_vector(2));
    x1 = input_vector(1);
    x2 = input_vector(2);
    gradient_vector = [2*(x1+i), 2*(x2-i) ]';

end

