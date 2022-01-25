function x = BarycentricToCartesian(elementInfo)
n = size(elementInfo.nodes,2);
x = Multinomials(n, 1, n+1);
M = [ones(n+1,1), elementInfo.nodes]';
x.coefficient = inv(M);
end

