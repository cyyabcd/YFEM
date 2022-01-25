function solution = NonNegativeIntegerSolutionEq(n, k)
%求 x_1+x_2+...+x_n = k 的非负整数解, 由数学推导易知共 nchoosek(k+n-1, n-1) 个
solutionNum = nchoosek(k+n-1, n-1);
solution = zeros(solutionNum, n);
solution(solutionNum, n) = k;
t = 0;
if n>=2
    for i = 0:k-1
        solutionNum_ = nchoosek(k-i+n-2, n-2);
        solution(t+1:t+solutionNum_, end) = i;
        solution(t+1:t+solutionNum_, 1:end-1) = NonNegativeIntegerSolutionEq(n-1, k-i);
        t = t + solutionNum_;
    end
end
end

