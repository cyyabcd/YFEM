function dofExpression = CreateDof(elementInfo, charLambdaToCartesian)
dofExpression = cell(120,1);

%% nodes
syms x y z
syms lambda1 lambda2 lambda3 lambda4
id = [1,1;1,2;1,3;2,2;2,3;3,3];
for i = 1:4
    for j = 1:6
        dofExpression{6*(i-1)+j,1} = eval(sprintf("@(fun) subs(fun(%d,%d), {x,y,z}, {%.15g, %.15g, %.15g});", id(j,1), id(j,2), elementInfo.nodes(i,1), elementInfo.nodes(i,2), elementInfo.nodes(i,3)));
    end
end

%% edges
id = [1,2;1,3;2,2;2,3;3,3];
for i = 1:6
    for j = 1:5
        for k = 1:2
            dofExpression{24+10*(i-1)+2*(j-1)+k,1} = eval(sprintf("@(fun) elementInfo.edgeLength(%d)*GaussIntegralAverage3dEdge((elementInfo.edgesTNN(%d,:,%d)*fun*elementInfo.edgesTNN(%d,:,%d)'*(%s)), elementInfo.nodes(elementInfo.edgeId(%d,:),:))",i, i, id(j,1), i,id(j,2), charLambdaToCartesian{elementInfo.edgeId(i,k),1}, i));
        end
    end
end

%% face
w = eye(3);
for i = 1:4
    for j = 1:3
        dofExpression{84+3*(i-1)+j,1} = eval(sprintf("@(fun) elementInfo.faceArea(%d)*GaussIntegralAverage3dFace(elementInfo.faceNormal(%d,:)*fun*w(%d,:)', elementInfo.nodes(elementInfo.faceId(%d,:),:))",i, i, j, i));
    end
end
id = [1 2;1 3;2 3];
for i = 1:4
    for j = 1:3
        dofExpression{96+6*(i-1)+j,1} = eval(sprintf("@(fun) elementInfo.faceArea(%d)*GaussIntegralAverage3dFace(elementInfo.faceNormal(%d,:)*fun*(%s), elementInfo.nodes(elementInfo.faceId(%d,:),:))",i, i, charLambdaToCartesian{elementInfo.faceId(i,j),1}, i));
    end
    for j = 1:3
        dofExpression{96+6*(i-1)+3+j,1} = eval(sprintf("@(fun) elementInfo.faceArea(%d)*GaussIntegralAverage3dFace(elementInfo.faceNormal(%d,:)*fun*(%s)*(%s), elementInfo.nodes(elementInfo.faceId(%d,:),:))",i, i, charLambdaToCartesian{elementInfo.faceId(i,id(j,1)),1}, charLambdaToCartesian{elementInfo.faceId(i,id(j,2)),1}, i));
    end
end
end
