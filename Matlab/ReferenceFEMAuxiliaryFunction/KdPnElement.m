function [kdPnBase, kdPnDof] = KdPnElement(n, k)
% k维下Pn元的基
baseNum = nchoosek(n+k,k);
baseFaceCoefficient = zeros((n+1)*(k+1), n+2);
baseFaceFactor = cell(k,1);
for i = 1:k
    baseFaceFactor{i} = Multinomials(n+1, 1, baseNum);
end
kdPnBase = 1;
kdPnDof = cell(baseNum,1);
for i = 1:n+1
    baseFaceCoefficient(1 + (i-1)*(k+1): i*(k+1), i+1) = 1;
    baseFaceCoefficient(1 + (i-1)*(k+1): i*(k+1), 1) = -(0:1/k:1)';
end
inds = NonNegativeIntegerSolutionEq(n+1,k);
indValues = inds/k;
for i = 1:baseNum
    q = 0;
    for j = 1:n+1
        for l = 0:inds(i,j)-1
            q = q+1;
            baseFaceFactor{q}.coefficient(i,:) = baseFaceCoefficient((j-1)*(k+1) +l+1,:);
        end
    end
    kdPnDof{i} = @(fun) fun.Evaluation(indValues(i,:));
end
for i = 1:k
    kdPnBase = kdPnBase *baseFaceFactor{i};
end
factor = zeros(baseNum, 1);
for i=1:baseNum
    factor(i) = kdPnBase.Evaluation(indValues(i,:),i);
end
kdPnBase = kdPnBase/factor;
end

