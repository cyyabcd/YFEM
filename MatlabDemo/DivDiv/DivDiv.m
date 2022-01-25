%% 添加路径
addpath(genpath("..\..\Matlab"));
%% 几何信息
N = 1;
[elementList, nodeList] = TetrahedronMesh(N);
nodeNum = (N+1)^3;
elementNum = 6*N^3;

%% 参考单元
referenceDofNum = 120;

% 3dP3 元基函数
[FEM3dP3LambdaBase, FEM3dP3LambdaDof] = KdPnElement(3, 3);
[FEM3dP1LambdaBase, FEM3dP1LambdaDof] = KdPnElement(3, 1);

%% 测试部分
% M = zeros(20);
% for i = 1:20
%     M(:,i) =  kdPnDof{i}(kdPnBase);
% end
% M = IgnoreSmallErrors(M);

%% 对称矩阵基 symmetricTensorBase(:,:,i) 是第i个基
symmetricTensorBase = CreateSymmetricTensorBase();

%% 单元上刚度矩阵
A = zeros(referenceDofNum, referenceDofNum, 6);
B = zeros(referenceDofNum, 4, 6);
C = zeros(4, 4, 6);
elementInfo = cell(6,1);
sigmaBase = cell(6,1);
sigmaDivDivBase = cell(6,1);
uBase = cell(6,1);
Dof = cell(6,1);

for i = 1:6
    elementInfo{i,1} = CreateGeometryInformationOnElement(elementList(i,:), nodeList);
end
for i = 1:6
    [sigmaBase{i,1}, sigmaDivDivBase{i,1}, uBase{i,1}, Dof{i,1}] = CalculateBaseOnElement(elementInfo{i,1}, FEM3dP3LambdaBase, FEM3dP1LambdaBase, symmetricTensorBase, referenceDofNum);
    for i1 = 1:3
        for j1 = 1:3
            sigmaBase{i}{i1,j1}.IgnoreSmallErrors();
        end
    end
    sigmaDivDivBase{i,1}.IgnoreSmallErrors();
end

for i = 1:6
    B(:,:,i) = CreateStiffnessMatrixMul(sigmaDivDivBase{i,1}, uBase{i,1}, elementInfo{i,1});
end
for i = 1:6
    C(:,:,i) = CreateStiffnessMatrixMul(uBase{i,1}, uBase{i,1}, elementInfo{i,1});
end
parfor i = 1:6
    A(:,:,i) = CreateStiffnessMatrixTensor(sigmaBase{i,1}, sigmaBase{i,1}, elementInfo{i,1});
end
A = IgnoreSmallErrors(A);
B = IgnoreSmallErrors(B);
C = IgnoreSmallErrors(C);
[edgeNum, faceNum, edgeMatrix, faceMatrix] = CreateEdgeAndFaceNum(elementList);
[edgeList, faceList, elementToEdge, elementToFace] = CreateEdgeAndFace(elementList, edgeNum, faceNum, edgeMatrix, faceMatrix);
[elementToDof, dofNum] = CreateElementToDof(elementList, edgeNum, faceNum, elementToEdge, elementToFace);
[elementToDofu, dofNumu] = CreateElementToDofu(elementList);
[LHS, RHS] = CreateStiffnessMatrixOnMesh(A, B, C, elementToDof, elementToDofu);
eign = 1./eigs(RHS, LHS)