function ind = ExponentIndInNonNegativeIntegerSolutionEq(exponent)
% 指数 exponent 对应 NonNegativeIntegerSolutionEq 中的位置
n = length(exponent);
k = sum(exponent);
ind = 0;
if n>=2
for i = 0:exponent(end)-1
    ind = ind + nchoosek(k-i+n-2, n-2);
end
ind = ind + ExponentIndInNonNegativeIntegerSolutionEq(exponent(1:end-1));
else
    ind = 1;
end

end

