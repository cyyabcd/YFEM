classdef ReferenceFEM < handle
    %ReferenceFEM 记录组装总刚时所需要的FEM的信息,本质上只需要基函数及其连续性即可即可
    %   referenceDofNum     自由度个数, 同时也是基函数个数
    %   baseFunction        基函数
    %   continuity          基函数的连续性
    %   dofFunctions        基函数对应的自由度
    properties
        referenceDofNum
        baseFunction
        continuity
        dofFunctions
    end
    
    methods
        function self = ReferenceFEM(referenceDofNum, baseFunction, continuity, varargin)
            self.referenceDofNum = referenceDofNum;
            self.baseFunction = baseFunction;
            self.continuity = continuity;
            if nargin>3
                self.dofFunctions = varargin{1};
            end
        end
        
    end
end

