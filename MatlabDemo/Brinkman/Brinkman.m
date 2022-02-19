%% 添加路径
addpath(genpath(['..' filesep  '..' filesep 'Matlab']));
%% 几何信息

N = 1; 
[elementList, nodeList] = CubeMesh(N, [1 1 1], [0 0 0]);
nodeNum = (N+1)^3;
elementNum = N^3;

pde=example1;

%% 参考单元
referenceDofNum = 30;
elementInfo = CreateGeometryInformationOnCubeElement(elementList(1,:), nodeList);

[elementToFace,NF]= CreateElementToFace(elementList);
elementToDof= CreateElementToDof(elementList);

elementToDofu=1:elementNum;


[femBase, bubbleBase, shapeSpace, bubbleSpace] = CalculateBrinkmanBaseOnElement(elementInfo, referenceDofNum);


for i = 1:3
    femBase{i}.IgnoreSmallErrors();
    bubbleBase{i}.IgnoreSmallErrors();
end
pressureBase = Multinomials(3, 0, 1);
pressureBase.coefficient(1) = 1;


GradFemBase = MultinomialsTensorGrad(femBase); % tensor 
divFemBase = MultinomialsTensorDiv(femBase);% vector 
GradBubbleBase = MultinomialsTensorGrad(bubbleBase); %tensor 

% stiffness matrix on ref cube
A = CreateStiffnessMatrixTensor(GradFemBase, GradFemBase, elementInfo);
B = CreateStiffnessMatrixTensor(GradBubbleBase, GradFemBase, elementInfo);
C = CreateStiffnessMatrixTensor(GradBubbleBase, GradBubbleBase, elementInfo);
D = CreateStiffnessMatrixMul(divFemBase, pressureBase, elementInfo);

AA = [A, B'; B,C];
% LHS
LHS = CreateStiffnessMatrixGlobally(AA, D, elementToDof, elementToDofu);

% RHS
F = getF(nodeList,elementList,femBase,bubbleBase,pde,elementToDof);
RHS = [F;zeros(elementNum,1)];




    


%% Global
% [LHS, RHS] = CreateStiffnessMatrixGlobally(AA, D, F,elementToDof, elementToDofu);






%% 
%A = CreateStiffnessMatrixTensor(epsilonFemBase, epsilonFemBase, elementInfo);
%B = CreateStiffnessMatrixTensor(epsilonBubbleBase, epsilonFemBase, elementInfo);
%C = CreateStiffnessMatrixTensor(epsilonBubbleBase, epsilonBubbleBase, elementInfo);
%D = CreateStiffnessMatrixMul(divFemBase, pressureBase, elementInfo);
%epsilonFemBase = MultinomialsTensorSymmetricalGradient(femBase);
%epsilonBubbleBase = MultinomialsTensorSymmetricalGradient(bubbleBase);

