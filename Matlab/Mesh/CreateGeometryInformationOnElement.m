function Info = CreateGeometryInformationOnElement(element, NodeList)
%% element
Info.element = element;
Info.type = "simplex";
%% nodes
Info.nodes = NodeList(element,:);

%% edges
Info.edgeId = [1 2;1 3;1 4;2 3;2 4;3 4];
Info.edge = sort(element(Info.edgeId), 2);
Info.edgeTangential = NodeList(Info.edge(:,2), :) - NodeList(Info.edge(:,1), :);
Info.edgeLength = sqrt(sum(Info.edgeTangential.*Info.edgeTangential, 2));
Info.edgeTangential = Info.edgeTangential./Info.edgeLength;
Info.edgeNormal1 = zeros(6,3);
Info.edgeNormal2 = zeros(6,3);
for e = 1:6
    normal = null(Info.edgeTangential(e,:));
    Info.edgeNormal1(e,:) = normal(:,1);
    Info.edgeNormal2(e,:) = normal(:,2);
end
Info.edgesTNN = zeros(6,3,3);
Info.edgesTNN(:,:,1) = Info.edgeTangential;
Info.edgesTNN(:,:,2) = Info.edgeNormal1;
Info.edgesTNN(:,:,3) = Info.edgeNormal2;

%% faces
Info.faceId = [1 2 3;1 2 4;1 3 4;2 3 4];
Info.face = sort(element(Info.faceId),2);
Info.faceArea = zeros(4,1);
Info.faceNormal = zeros(4,3);
Info.faceTangential1 = zeros(4,3);
Info.faceTangential2 = zeros(4,3);
for f = 1:4
    faceNodes = NodeList(Info.face(f, :), :);
    Info.faceTangential1(f,:) = faceNodes(2,:) - faceNodes(1,:);
    Info.faceTangential2(f,:) = faceNodes(3,:) - faceNodes(1,:);
    Info.faceArea(f) = 0.5*norm(cross(Info.faceTangential1(f,:), Info.faceTangential2(f,:)));
    Info.faceTangential1(f,:) = Info.faceTangential1(f,:)/norm(Info.faceTangential1(f,:));
    Info.faceTangential2(f,:) = Info.faceTangential2(f,:) - dot(Info.faceTangential1(f,:), Info.faceTangential2(f,:))*Info.faceTangential1(f,:);
    Info.faceTangential2(f,:) = Info.faceTangential2(f,:)/norm(Info.faceTangential2(f,:));
    Info.faceNormal(f,:) = cross(Info.faceTangential1(f,:), Info.faceTangential2(f,:));
end
Info.facesNTT = zeros(4,3,3);
Info.facesNTT(:,:,1) = Info.faceNormal;
Info.facesNTT(:,:,2) = Info.faceTangential1;
Info.facesNTT(:,:,3) = Info.faceTangential2;

%% volume
Info.volume = abs(det([ones(4,1), Info.nodes]))/6;
end

