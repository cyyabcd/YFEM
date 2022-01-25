function [edgeList, faceList, elementToEdge, elementToFace] = CreateEdgeAndFace(elementList, edgeNum, faceNum, edgeMatrix, faceMatrix)
N = power(size(elementList,1)/6,1/3);
nodeNum = (N+1)^3;
edgeList = zeros(edgeNum, 2);
faceList = zeros(faceNum, 3);
edgeMatrix = sparse(nodeNum, nodeNum);
faceMatrix = cell(nodeNum,1);
for i = 1:nodeNum
    faceMatrix{i,1} = sparse(nodeNum, nodeNum);
end
edgeCount = 0;
faceCount = 0;
edgeId = [1 2;1 3;1 4;2 3;2 4;3 4];
faceId = [1 2 3;1 2 4;1 3 4;2 3 4];
elementToEdge = zeros(size(elementList,1), 6);
elementToFace = zeros(size(elementList,1), 4);
for i=1:size(elementList,1)
    for j = 1:6
        edge = elementList(i,edgeId(j,:));
        if edgeMatrix(edge(1), edge(2)) == 0
            edgeCount = edgeCount + 1;
            edgeList(edgeCount,:) = edge;
            edgeMatrix(edge(1), edge(2)) = edgeCount;
        end
        elementToEdge(i,j) = edgeMatrix(edge(1), edge(2));
    end
    for j = 1:4
        face = elementList(i,faceId(j,:));
        if faceMatrix{face(1),1}(face(2), face(3)) == 0
            faceCount = faceCount + 1;
            faceList(faceCount, :) = face;
            faceMatrix{face(1),1}(face(2), face(3)) = faceCount;
        end
        elementToFace(i,j) = faceMatrix{face(1),1}(face(2), face(3));
    end
end

end

