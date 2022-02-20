function [elementToFace, totalFace]= CreateElementToFace(elementList)
NT = size(elementList, 1); 
markfaceId = [1 2 3 4;1 2 5 6;1 3 5 7;2 4 6 8;3 4 7 8;5 6 7 8];

totalFace = zeros(NT*6,4);
for i = 1:6
    totalFace(NT*(i-1)+1:NT*i,:) = uint32(sort(elementList(:,markfaceId(i,:))));
end

[totalFace, ~, ib] = unique(totalFace,'rows','legacy');
elementToFace = reshape(ib,NT,6);
end