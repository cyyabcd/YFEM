function [femBase, bubbleBase, shapeSpace, bubbleSpace] = CalculateBrinkmanBaseOnElement(elementInfo, referenceDofNum)
nDim = 3;

%% ShapeSpace
shapeSpace = cell(nDim, 1);
for i=1:3
    shapeSpace{i} = Multinomials(nDim, 2, 18);
    shapeSpace{i}.coefficient((i-1)*4+1:4*i,1:4) = eye(4); 
end
shapeSpace{1}.coefficient(13:18,5:10) = [0 3 0 0 0 0;-1 0 0 0 0 0;-1 0 0 0 0 0;0 0 0 3 0 0;0 0 0 -1 0 0;0 -1 0 0 0 0];
shapeSpace{2}.coefficient(13:18,5:10) = [0 0 -1 0 0 0;0 3 0 0 0 0;0 -1 0 0 0 0;0 0 0 0 -1 0;0 0 0 0 3 0;0 0 -1 0 0 0];
shapeSpace{3}.coefficient(13:18,5:10) = [0 0 0 0 -1 0;0 0 0 -1 0 0;0 0 0 3 0 0;0 0 0 0 0 -1;0 0 0 0 0 -1;0 0 0 0 3 0];

FEM3dP1 = Multinomials(nDim, 1, 4);
FEM3dP1.coefficient = eye(4);
FEM3dP1Cell = cell(4,1);
for i=1:4
    FEM3dP1Cell{i} = FEM3dP1.Get(i);
end

ShapeDof = cell(18, 1);
ind = [ones(6,1) elementInfo.faceVariable+1];
for i = 1:6
    for j=1:3
        ShapeDof{3*(i-1)+j} = eval(sprintf("@(fun) MultinomialsIntegralOnCube(MultinomialsTensorTimesVV(fun, elementInfo.faceNormal(%d, :))*FEM3dP1Cell{%d}, elementInfo.nodes(elementInfo.faceId(%d,:),:), 2)", i, ind(i, j), i));
    end
end

M = zeros(18);
for i=1:18
    M(:,i) = ShapeDof{i}(shapeSpace);
end

femBase =cell(3,1);
for i=1:3
    femBase{i}= shapeSpace{i}.LinearTransform(M);
end
Mx = zeros(18);
for i=1:18
    Mx(:,i) = ShapeDof{i}(femBase);
end

%% BubbleSpace
BBase_ = cell(6,1);
Bk = Multinomials(3, 0, 1);
Bk.coefficient(1) = 1;
Bk_ = cell(6,1);

for i = 1:6
    Bk_{i} = Multinomials(3, 0, 1);
    Bk_{i}.coefficient(1) = 1;
end

for i = 1:6
    BBase_{i} = Multinomials(3, 1, 1);
    BBase_{i}.coefficient(1) = 1;
    BBase_{i}.coefficient(ceil(i/2)+1) = (-1)^i;
    Bk = Bk*BBase_{i};
    for j=1:6
        if j~=i
            Bk_{j} = Bk_{j}*BBase_{i};
        end
    end
end

for i = 1:6
    Bk_{i} = Bk_{i}*Bk;
end
Bk = Multinomials(3, Bk_{1}.k, 12);
for i = 1:12
    Bk.coefficient(i,:) = Bk_{ceil(i/2)}.coefficient;
end
BBase_ = cell(3, 1);

Normals = [ 0 0 0  0 0 -1  0 1  0 1 0 -1;
            0 1 0 -1 0  0  0 0 -1 0 1  0;
           -1 0 1  0 1  0 -1 0  0 0 0  0];
for i = 1:3
    BBase_{i} = Bk*Normals(i,:)';
end
bubbleSpace = MultinomialsTensorCurl(BBase_);
bubbleDof = cell(12, 1);
I = eye(3);
for i = 1:6
    for j=1:2
        bubbleDof{2*(i-1)+j} = eval(sprintf("@(fun) MultinomialsIntegralOnCube(MultinomialsTensorTimesVV(fun, cross(elementInfo.faceNormal(%d, :), I(%d,:))), elementInfo.nodes(elementInfo.faceId(%d,:),:), 2)", i, elementInfo.faceVariable(i, j), i));
    end
end

M = zeros(12);
for i=1:12
    M(:,i) = bubbleDof{i}(bubbleSpace);
end

bubbleBase =cell(3,1);
for i=1:3
    bubbleBase{i}= bubbleSpace{i}.LinearTransform(M);
end
M = zeros(12);
for i=1:12
    M(:,i) = bubbleDof{i}(bubbleBase);
end
end

