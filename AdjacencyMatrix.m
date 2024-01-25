function A = AdjacencyMatrix(n)
    A = ones(n, n) - eye(n); % 初始化为全1，并将对角线设为0
end
