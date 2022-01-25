function solution = NonNegativeIntegerSolutionLeq(n, k)
%求 x_1+x_2+...+x_n <= k 的非负整数解, 由数学推导易知共 nchoosek(n+k, n) 个
solutionNum = nchoosek(k+n, n);
solution = zeros(solutionNum, n);
t = 0;
for i = 0:k
    solutionNum_ = nchoosek(i+n-1, n-1);
    solution(t+1:t+solutionNum_, :) = NonNegativeIntegerSolutionEq(n, i);
    t = t+solutionNum_;
end
end

