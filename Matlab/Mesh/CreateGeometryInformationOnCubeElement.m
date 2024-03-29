function Info = CreateGeometryInformationOnCubeElement(element, NodeList)
%% element
Info.element = element;
Info.type = "cube";
%% nodes
Info.nodes = NodeList(element,:);
Info.lower = min(Info.nodes);
Info.upper = max(Info.nodes);
%% edges
Info.edgeId = [1 2;1 3;1 5;2 4;2 6;3 4;3 7;4 8;5 6;5 7;6 8;7 8];
Info.edge = sort(element(Info.edgeId), 2);
Info.edgeTangential = NodeList(Info.edge(:,2), :) - NodeList(Info.edge(:,1), :);
Info.edgeLength = sqrt(sum(Info.edgeTangential.*Info.edgeTangential, 2));
Info.edgeTangential = Info.edgeTangential./Info.edgeLength;
Info.edgeNormal1 = zeros(12,3);
Info.edgeNormal2 = zeros(12,3);
for e = 1:12
    normal = null(Info.edgeTangential(e,:));
    Info.edgeNormal1(e,:) = normal(:,1);
    Info.edgeNormal2(e,:) = normal(:,2);
end
Info.edgesTNN = zeros(12,3,3);
Info.edgesTNN(:,:,1) = Info.edgeTangential;
Info.edgesTNN(:,:,2) = Info.edgeNormal1;
Info.edgesTNN(:,:,3) = Info.edgeNormal2;

%% faces
Info.faceId = [1 2 3 4;1 2 5 6;1 3 5 7;2 4 6 8;3 4 7 8;5 6 7 8];
Info.face = sort(element(Info.faceId),2);
Info.faceArea = zeros(6,1);
Info.faceNormal = zeros(6,3);
Info.faceTangential1 = zeros(6,3);
Info.faceTangential2 = zeros(6,3);
Info.faceVariable = zeros(6, 2);
for f = 1:6
    faceNodes = NodeList(Info.face(f, :), :);
    Info.faceTangential1(f,:) = faceNodes(2,:) - faceNodes(1,:);
    Info.faceTangential2(f,:) = faceNodes(3,:) - faceNodes(1,:);
    dx = max(faceNodes)-min(faceNodes);
    ind = [1 2 3];
    Info.faceVariable(f,:) = ind(dx~=0);
    Info.faceArea(f) = prod(dx(dx~=0));
    Info.faceTangential1(f,:) = Info.faceTangential1(f,:)/norm(Info.faceTangential1(f,:));
    Info.faceTangential2(f,:) = Info.faceTangential2(f,:) - dot(Info.faceTangential1(f,:), Info.faceTangential2(f,:))*Info.faceTangential1(f,:);
    Info.faceTangential2(f,:) = Info.faceTangential2(f,:)/norm(Info.faceTangential2(f,:));
    Info.faceNormal(f,:) = cross(Info.faceTangential1(f,:), Info.faceTangential2(f,:));
end
Info.facesNTT = zeros(6,3,3);
Info.facesNTT(:,:,1) = Info.faceNormal;
Info.facesNTT(:,:,2) = Info.faceTangential1;
Info.facesNTT(:,:,3) = Info.faceTangential2;

%% volume
Info.volume = prod(max(Info.nodes)-min(Info.nodes));
end

