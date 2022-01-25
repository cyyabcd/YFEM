function [edgeNum, faceNum, edgeMatrix, faceMatrix] = CreateEdgeAndFaceNum(elementList)

N = power(size(elementList,1)/6,1/3);
edgeMatrix = sparse((N+1)^3, (N+1)^3);
faceMatrix = cell((N+1)^3,1);
for i = 1:(N+1)^3
    faceMatrix{i,1} = sparse((N+1)^3, (N+1)^3);
end

for i=1:size(elementList,1)
    ind = [elementList(i,[1,2]);elementList(i,[1,3]);elementList(i,[1,4]);elementList(i,[2,3]);elementList(i,[2,4]);elementList(i,[3,4])];
    edgeMatrix = edgeMatrix + sparse(ind(:,1),ind(:,2),1,(N+1)^3, (N+1)^3);
    ind = [elementList(i,[1,2,3]);elementList(i,[1,2,4]);elementList(i,[1,3,4]);elementList(i,[2,3,4])];
    for j = 1:4
        faceMatrix{ind(j,1),1}(ind(j,2),ind(j,3)) = faceMatrix{ind(j,1),1}(ind(j,2),ind(j,3))+1;
    end
end
edgeNum = nnz(edgeMatrix);
faceNum = 0;
for i =1:(N+1)^3
    faceNum = faceNum + nnz(faceMatrix{i,1});
end
end

