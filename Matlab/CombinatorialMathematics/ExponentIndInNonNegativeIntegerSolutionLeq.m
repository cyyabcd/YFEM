function ind = ExponentIndInNonNegativeIntegerSolutionLeq(exponent)
% 指数 exponent 对应 NonNegativeIntegerSolutionLeq 中的位置
k = sum(exponent);
if k == 0
    ind = 1;
else
    n = length(exponent);
    ind = ExponentIndInNonNegativeIntegerSolutionEq(exponent) + nchoosek(k-1+n, n);
end
end

