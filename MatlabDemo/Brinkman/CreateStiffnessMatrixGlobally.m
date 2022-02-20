function LHS = CreateStiffnessMatrixGlobally(A, B, elementToDof, elementToDofu)

elementNum = size(elementToDof,1);
totalDofNum = max(max(elementToDof));
totalDofNumu = max(max(elementToDofu));
dofNum = size(elementToDof, 2);
dofNumu = size(elementToDofu, 2);

MA = sparse(totalDofNum, totalDofNum);
MB = sparse(totalDofNum, totalDofNumu);


for e = 1:elementNum
    TA = elementToDof(e,:)'*ones(1,dofNum);
    TTA = TA';
    TB = elementToDof(e,:)'*ones(1,dofNumu);
    TTB = ones(dofNum,1)*elementToDofu(e,:);

    indA = A~=0;
    indB = B~=0;

    MA = MA + sparse(TA(indA),TTA(indA), A(indA), totalDofNum, totalDofNum);
    MB = MB + sparse(TB(indB),TTB(indB), B(indB), totalDofNum, totalDofNumu);

end
LHS = [MA MB; MB' sparse(totalDofNumu, totalDofNumu)];

end

