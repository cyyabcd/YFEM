classdef Multinomials < handle
    properties
        n;              % 未知数个数
        k;              % 次数
        m;              % 多项式个数
        coefficientNum;
        coefficient;    % 系数
        exponent;       % 系数对应的指数
    end
    
    methods 
        function self = Multinomials(n, k, m)
            self.n = n;
            self.k = k;
            self.m = m;
            self.coefficientNum = nchoosek(n+k, n);
            self.coefficient = zeros(m, self.coefficientNum);
            self.exponent = NonNegativeIntegerSolutionLeq(n, k);
        end
        
        function f = Get(self, i)
            f = Multinomials(self.n, self.k, 1);
            f.coefficient = self.coefficient(i,:);
        end
        
        function value = Evaluation(self, x, varargin)
            x_ = x.^self.exponent;
            if nargin == 2
                value = self.coefficient * prod(x_, 2);
            else
                value = self.coefficient(varargin{1}, :)* prod(x_, 2);
            end
        end
        
        function f = Substitute(self, T)
            % 将多项式的变量依次用T的多项式替换,
            % T可以是self.n大小的cell 或者 T.m=self.n的multinomials.
            if isa(T, 'Multinomials')
                assert(self.n == T.m, 'The number of variable are not the same!');
                Tk = T.k;
                Tc = cell(T.m, 1);
                for i = 1:T.m
                    Tc{i} = Multinomials(T.n, T.k, 1);
                    Tc{i}.coefficient = T.coefficient(i,:);
                end
                Tn = T.n;
            elseif iscell(T)
                assert(self.n == numel(T), 'The number of variable dismatch!');
                Tc = T;
                Tk = zeros(self.n,1);
                Tn = zeros(self.n,1);
                for i = 1:self.n
                    Tk(i) = T{i}.m;
                    Tn(i) = T{i}.n;
                end
                assert(max(Tn) == min(Tn), 'The variable number of T dismatch!');
                Tk = max(Tk);
                Tn = max(Tn);
            else
                assert(0 , 'Not support!');     
            end
            
            f = Multinomials(Tn, self.k*Tk, self.m);
            f.coefficient(:,1) = self.coefficient(:,1);
            for i = 2:self.coefficientNum
                if any(self.coefficient(:,i))
                    p = 1;
                    for j = 1:self.n
                        for k = 1:self.exponent(i,j)
                            p = p*Tc{j};
                        end
                    end
                    f.coefficient(:, 1:p.coefficientNum) = f.coefficient(:, 1:p.coefficientNum) + self.coefficient(:,i)*p.coefficient;
                end
            end
            f.Simplify();
        end
        
        function self = Simplify(self)
            for degree = self.k:-1:0
                if degree == 0
                    break;
                end
                ind = nchoosek(self.n+degree-1, self.n)+1:nchoosek(self.n+degree, self.n);
                if any(any(self.coefficient(:, ind)))
                    break;
                end
            end
            if degree~=self.k
                ind = nchoosek(self.n+degree, self.n)+1:nchoosek(self.n+self.k, self.n);
                self.k = degree;
                self.coefficient(:, ind) = [];
                self.coefficientNum = nchoosek(self.n+self.k, self.n);
                self.exponent(ind,:) = [];
            end
        end
        
        function f = plus(f1, f2)
            if isa(f2, 'numeric')
                f = Multinomials(f1.n, f1.k, f1.m);
                f.coefficient = f1.coefficient;
                f.coefficient(:,1) = f.coefficient(:,1) + f2;
            elseif isa(f1, 'numeric')
                f = Multinomials(f2.n, f2.k, f2.m);
                f.coefficient = f2.coefficient;
                f.coefficient(:,1) = f.coefficient(:,1) + f1;
            else
                assert(f1.n==f2.n, 'The number of variable for f1 and f2 are not the same!');
                assert(f1.m==f2.m, 'The number of multinomials for f1 and f2 are not the same!');
                if f1.n>f2.n
                    f = Multinomials(f1.n, f1.k, f1.m);
                    f.coefficient = f1.coefficient + [f2.coefficient zeros(f2.m, f.coefficientNum-f2.coefficientNum)];
                else
                    f = Multinomials(f2.n, f2.k, f2.m);
                    f.coefficient = f2.coefficient + [f1.coefficient zeros(f1.m, f.coefficientNum-f1.coefficientNum)];
                end
            end
        end
        
        function f = minus(f1, f2)
            if isa(f2, 'numeric')
                f = Multinomials(f1.n, f1.k, f1.m);
                f.coefficient = f1.coefficient;
                f.coefficient(:,1) = f.coefficient(:,1) - f2;
            elseif isa(f1, 'numeric')
                f = Multinomials(f2.n, f2.k, f2.m);
                f.coefficient = -f2.coefficient;
                f.coefficient(:,1) = f.coefficient(:,1) + f1;
            else
                assert(f1.n==f2.n, 'The number of variable for f1 and f2 are not the same!');
                assert(f1.m==f2.m, 'The number of multinomials for f1 and f2 are not the same!');
                if f1.n>f2.n
                    f = Multinomials(f1.n, f1.k, f1.m);
                    f.coefficient = f1.coefficient - [f2.coefficient zeros(f2.m, f.coefficientNum-f2.coefficientNum)];
                else
                    f = Multinomials(f2.n, f2.k, f2.m);
                    f.coefficient = [f1.coefficient zeros(f1.m, f.coefficientNum-f1.coefficientNum)] - f2.coefficient;
                end
            end
        end
        
        function f = uminus(f1)
            f = Multinomials(f1.n, f1.k, f1.m);
            f.coefficient = -f1.coefficient;
        end
        
        function f = mtimes(f1, f2)
            if isa(f2, 'numeric')
                f = Multinomials(f1.n, f1.k, f1.m);
                f.coefficient = f1.coefficient .* f2;
            elseif isa(f1, 'numeric')
                f = Multinomials(f2.n, f2.k, f2.m);
                f.coefficient = f2.coefficient .* f1;
            else
                assert(f1.n==f2.n, 'The number of variable for f1 and f2 are not the same!');
                assert(f1.m==f2.m||f1.m==1||f2.m==1, 'The number of multinomials for f1 and f2 are not the same!');
                fm = max(f1.m, f2.m);
                f = Multinomials(f1.n, f1.k+f2.k, fm);
                for i = 1:f.coefficientNum
                    ids = CubeGrid(zeros(1,f.n), f.exponent(i,:));
                    for j = 1:size(ids, 1)
                        j1 = ExponentIndInNonNegativeIntegerSolutionLeq(ids(j,:));
                        j2 = ExponentIndInNonNegativeIntegerSolutionLeq(f.exponent(i,:) - ids(j,:));
                        if j1<=f1.coefficientNum&&j2<=f2.coefficientNum
                            f.coefficient(:, i) = f.coefficient(:, i) + f1.coefficient(:, j1).*f2.coefficient(:, j2);
                        end
                    end
                end
            end
        end
        
        function f = mrdivide(f1, f2)
            assert(isa(f2, 'numeric'), 'Not support!');
            f = Multinomials(f1.n, f1.k, f1.m);
            f.coefficient = f1.coefficient./f2;
        end
        
        function dx = Derivate(self, varid)
            if self.k == 0
                dx = Multinomials(self.n, 0, self.m);
            else
                assert(varid<=self.n, 'varid is greater than variable number!');
                remove = self.exponent(:, varid)==0;
                scalar = self.exponent(:, varid);
                p = self.coefficient.*scalar';
                dx = Multinomials(self.n, self.k-1, self.m);
                dx.coefficient = p(:, ~remove);
            end
        end
        
        function value = IntegralOnCube(self, cubeNodes, d)
            assert(self.n==size(cubeNodes, 2), 'Dimension dismatch!');
            assert(2^d==size(cubeNodes, 1), 'The number of nodes dismatch!');
            assert(d<=self.n, "The dimension of integral is greater than the number of variable!");
            up = max(cubeNodes);
            down = min(cubeNodes);
            dx = up - down;
            IntegralDim = dx~=0; 
            integralFactor = zeros(self.coefficientNum, 1);
            for i = 1:self.coefficientNum
                e = self.exponent(i,IntegralDim) + 1;
                integralFactor(i) = prod(up(IntegralDim).^e-down(IntegralDim).^e)/prod(e);
                integralFactor(i) = integralFactor(i)*prod(up(~IntegralDim).^self.exponent(i,~IntegralDim));
            end
            value = self.coefficient*integralFactor;
        end
        
        function value = IntegralAverageOnSimplex(self, simplexNodes, d)
            assert(self.n==size(simplexNodes, 2), 'Dimension dismatch!');
            assert((d+1)==size(simplexNodes, 1), 'The number of nodes dismatch!');
            assert(d<=self.n, "The dimension of integral is greater than the number of variable!");
            lambda = Multinomials(d, 1, self.n);
            lambda.coefficient(:, 1) = simplexNodes(1, :)';
            lambda.coefficient(:, 2:end) = (simplexNodes(2:end, :) - ones(d,1)*simplexNodes(1, :))';
            f = self.Substitute(lambda);
            integralFactor = zeros(f.coefficientNum, 1);
            for i = 1:f.coefficientNum
                e = f.exponent(i,:);
                integralFactor(i) = prod(factorial(e))/factorial(sum(e)+d);
            end
            value = (f.coefficient*integralFactor)*factorial(d);
        end
        
        function f = LinearTransform(self, M, varargin)
            if nargin>2 && ~varargin{1}
                f = Multinomials(self.n, self.k, size(M,1));
                f.coefficient = M*self.coefficient;
            else
                assert(size(M,1)==self.m && size(M,1)==size(M,2), "Size dismatch!");
                f = Multinomials(self.n, self.k, self.m);
                f.coefficient = M\self.coefficient;
            end
            
        end
        
        function self = IgnoreSmallErrors(self)
            self.coefficient = IgnoreSmallErrors(self.coefficient);
        end
        
        function str = ToString(self, i, variablename)
            str = "";
            for j = 1:self.coefficientNum
                if self.coefficient(i,j)>0&&j~=1
                    str = str + "+";
                elseif self.coefficient(i,j)<0
                    str = str + "-";
                else
                    continue
                end
                str_ = "";
                for l = 1:self.n
                    if self.exponent(j, l)==1
                        str_ = str_ + sprintf("%s",variablename(l));
                    elseif self.exponent(j, l)>1
                        str_ = str_ + sprintf("%s^%d",variablename(l), self.exponent(j, l));
                    end
                end
                if abs(self.coefficient(i,j))==1
                    str = str + str_;
                else
                    str = str + string(abs(self.coefficient(i,j))) + str_;
                end
            end
            if str==""
                str="0";
            end
        end
%         function value = GaussIntegralAverageOnSimplex(self, cube)
%             
%         end
    end
end