function y = select_neighbor(Lrow)
N = length(Lrow);
count = 1;
for j = 1:N
       if Lrow(j) < 0
           y(count) = j;
           count = count+1;
       end
end