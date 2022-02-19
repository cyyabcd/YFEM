function [elementToEdge,NE]= CreateElementToEdge(elementList)
NT = size(elementList, 1); 
markedgeId = [1 2;1 3;1 5;2 4;2 6;3 4;3 7;4 8;5 6;5 7;6 8;7 8];
totalEdge = zeros(NT*12,2);
for i = 1:12
    totalEdge(NT*(i-1)+1:NT*i,:) = uint32(sort(elementList(:,markedgeId(i,:))));
end

[totalEdge, ~, ib] = unique(totalEdge,'rows','legacy');
NE= size(totalEdge,1);
elementToEdge = reshape(ib,NT,12);
end