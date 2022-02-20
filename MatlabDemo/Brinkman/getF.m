
function  F = getF(node,elem,v1h,v2h,pde,elementToDof)


%[~,dim] = size(node);
NT = size(elem,1);
%% Mesh size and Volume
hx = node(elem(:,2),1) - node(elem(:,1),1);
hy = node(elem(:,3),2) - node(elem(:,1),2);
hz = node(elem(:,5),3) - node(elem(:,1),3);
volume = abs(hx.*hy.*hz);
%% Gauss points
[GaussPt,weight] = quadOnCube(6);
lambdax = GaussPt(:,1);
lambday = GaussPt(:,2);
lambdaz = GaussPt(:,3);

nQuad = size(GaussPt,1);

%% evaluation of the basis function 
vhValue = zeros(30,nQuad,3);
for p = 1:nQuad
    pxyz =  node(elem(1,1),:)+[hx(1) hy(1) hz(1)].* GaussPt(p,:);
    for j = 1:3
        vhValue(1:18,p,j) = v1h{j}.Evaluation(pxyz);
        vhValue(19:30,p,j) = v2h{j}.Evaluation(pxyz);
    end
end

%% Get (f,v) on a general K 
fp = zeros(NT,nQuad,3);
for p = 1:nQuad   
    for k = 1:NT
        px = node(elem(k,1),1)+hx(k,1)*lambdax(p,1);
        py = node(elem(k,1),2)+hy(k,1)*lambday(p,1);
        pz = node(elem(k,1),3)+hz(k,1)*lambdaz(p,1);
        pxyz = [px,py,pz];
        fp(k,p,:) = pde.f(pxyz,1);
    end   
end 

fv = zeros(NT,30); %Nbasis = 30 on each K  %dot(fp(k,p,:),vhValue(i,p,:))*w(p)*volume 
for k = 1:NT
    for p = 1:nQuad
        for i = 1:30
            fv(k,i) = fv(k,i) + dot(fp(k,p,:),vhValue(i,p,:))*weight(p)*volume(k,1);
        end
    end
end

totalNdof = max(max(elementToDof));
F = zeros(totalNdof,1);
for k = 1:NT
    for i = 1:30
        F(elementToDof(k,i)) =  F(elementToDof(k,i))+ fv(k,i);
    end
end




end