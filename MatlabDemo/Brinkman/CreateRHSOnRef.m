function M = CreateRHSOnRef(f, base, elementInfo)
baseDofNum = base.m;
M = zeros(baseDofNum, 1);
for j = 1:baseDofNum
    p = f*base.Get(j);
    if elementInfo.type == "simplex"
    M(j,1) = p.IntegralAverageOnSimplex(elementInfo.nodes, base.n);
    elseif elementInfo.type == "cube"
        M(j,1) = p.IntegralOnCube(elementInfo.nodes, base.n); %? 
    end
end
if elementInfo.type == "simplex"
    M = M*elementInfo.volume;
end
end

