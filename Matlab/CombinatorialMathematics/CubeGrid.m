function solution = CubeGrid(lower, upper)
%求 start(i) <= x(i) <= end(i) 的整数解, 由数学推导易知共 \Pi (end(i)-start(i)) 个
indNum = upper-lower+1;
solutionNum = prod(indNum);
n = length(lower);

solution = zeros(solutionNum, n);
if n>1
    cubeGrid_ = CubeGrid(lower(2:end), upper(2:end));
    solutionNum_ = prod(indNum(2:end));
    solution(:,1) = reshape(repmat(lower(1):upper(1), [solutionNum_, 1]), [solutionNum,1]);
    solution(:, 2:end) = repmat(cubeGrid_, [indNum(1),1]);
else
    solution(:, 1) = lower(1):upper(1);
end
end