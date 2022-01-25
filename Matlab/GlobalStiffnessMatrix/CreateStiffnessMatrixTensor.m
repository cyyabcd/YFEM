function M = CreateStiffnessMatrixTensor(base1, base2, elementInfo)
base1DofNum = base1{1}.m;
base2DofNum = base2{1}.m;
M = zeros(base1DofNum, base2DofNum);
for j = 1:base2DofNum
    p = (base1{1})*(base2{1}.Get(j));
    for k = 2:numel(base1)
        p = p + (base1{k})*(base2{k}.Get(j));
    end
    if elementInfo.type == "simplex"
        M(:,j) = p.IntegralAverageOnSimplex(elementInfo.nodes, base1{1}.n);
    elseif elementInfo.type == "cube"
        M(:,j) = p.IntegralOnCube(elementInfo.nodes, base1{1}.n);
    end
end
if elementInfo.type == "simplex"
    M = M*elementInfo.volume;
end
end

