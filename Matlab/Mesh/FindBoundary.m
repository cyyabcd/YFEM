function [isBoundary] = FindBoundary(geometryList,isBoundaryNode)
    isBoundary = all(isBoundaryNode(geometryList), 2);
end

