%% 添加路径
addpath(genpath("..\..\Matlab"));
%% 几何信息

N = 1;
[elementList, nodeList] = CubeMesh(N, [1 1 1], [-1 -1 -1]);
nodeNum = (N+1)^3;
elementNum = N^3;


%% 参考单元
referenceDofNum = 30;
elementInfo = CreateGeometryInformationOnCubeElement(elementList(1,:), nodeList);

[femBase, bubbleBase, shapeSpace, bubbleSpace] = CalculateBrinkmanBaseOnElement(elementInfo, referenceDofNum);

for i = 1:3
    femBase{i}.IgnoreSmallErrors();
    bubbleBase{i}.IgnoreSmallErrors();
end
pBase = Multinomials(3, 0, 1);
pBase.coefficient(1) = 1;

divFemBase = MultinomialsTensorDiv(femBase);
epsilonFemBase = MultinomialsTensorSymmetricalGradient(femBase);
epsilonBubbleBase = MultinomialsTensorSymmetricalGradient(bubbleBase);

A = CreateStiffnessMatrixTensor(epsilonFemBase, epsilonFemBase, elementInfo);
B = CreateStiffnessMatrixTensor(epsilonBubbleBase, epsilonFemBase, elementInfo);
C = CreateStiffnessMatrixTensor(epsilonBubbleBase, epsilonBubbleBase, elementInfo);
D = CreateStiffnessMatrixMul(divFemBase, pBase, elementInfo);