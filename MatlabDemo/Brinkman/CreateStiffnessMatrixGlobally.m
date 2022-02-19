function LHS = CreateStiffnessMatrixGlobally(A, B, elementToDof, elementToDofu)

elementNum = size(elementToDof,1);
totalDofNum = max(max(elementToDof));
totalDofNumu = max(max(elementToDofu));
dofNum = size(elementToDof, 2);
dofNumu = size(elementToDofu, 2);

MA = sparse(totalDofNum, totalDofNum);
MB = sparse(totalDofNum, totalDofNumu);


for e = 1:elementNum
    q = e-floor((e-1)/6)*6;
    SA = A(:,:,q);
    SB = B(:,:,q);
    TA = elementToDof(e,:)'*ones(1,dofNum);
    TTA = TA';
    TB = elementToDof(e,:)'*ones(1,dofNumu);
    TTB = ones(dofNum,1)*elementToDofu(e,:);

    indA = SA~=0;
    indB = SB~=0;

    MA = MA + sparse(TA(indA),TTA(indA), SA(indA), totalDofNum, totalDofNum);
    MB = MB + sparse(TB(indB),TTB(indB), SB(indB), totalDofNum, totalDofNumu);

end
LHS = [MA MB; MB' sparse(totalDofNumu, totalDofNumu)];

end

