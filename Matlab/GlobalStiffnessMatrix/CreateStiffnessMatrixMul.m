function M = CreateStiffnessMatrixMul(base1, base2, elementInfo)
base1DofNum = base1.m;
base2DofNum = base2.m;
M = zeros(base1DofNum, base2DofNum);
for j = 1:base2DofNum
    p = base1*base2.Get(j);
    if elementInfo.type == "simplex"
    M(:,j) = p.IntegralAverageOnSimplex(elementInfo.nodes, base1.n);
    elseif elementInfo.type == "cube"
        M(:,j) = p.IntegralOnCube(elementInfo.nodes, base1.n);
    end
end
if elementInfo.type == "simplex"
    M = M*elementInfo.volume;
end
end

