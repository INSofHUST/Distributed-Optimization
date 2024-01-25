function W = Weight(L)

[m,n] = size(L);
W = zeros(m,n);
Degree = diag(L) + 1;

for i = 1:m
    for j = 1:n

        if L(i,j) == 0
            W(i,j) = 0;
        elseif L(i,j) < 0
            W(i,j) = 1 / (max(Degree(i),Degree(j)));
        end

    end
    W(i,i) = 1 - sum(W(i,:));
end
end

