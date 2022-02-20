function [isBoundaryNode] = FindBoundaryNode(NodeList, bf)
	isBoundaryNode = abs(bf(NodeList))<1e-5;
end

