
%Eg 2
%calculate the pde 
%[0,1]^3
% u = 0 on \partial\Omega 
% symmetric grad
% sigma n=0 on z=1 



syms x y z mu


%% 
u =[-x^2*y*z*(5*z - 2)*(x - 1)^2*(y - 1)*(z - 1)^2
    x*y^2*z*(5*z - 2)*(x - 1)*(y - 1)^2*(z - 1)^2
    4*x*y*z^2*(x - y)*(x - 1)*(y - 1)*(z - 1)^3];

p = (x-1/2)*(y-1/2)*(1-z);

%%
%symgrad
%Du is a tensor 
ux = diff(u(:,1),x,1);
uy = diff(u(:,1),y,1);
uz = diff(u(:,1),z,1);

Du = [ux,uy,uz];

Eu = (Du+Du.')/2;

Deltau = diff(Eu(:,1),x,1)+diff(Eu(:,2),y,1)+diff(Eu(:,3),z,1);



%Dp  is a vector 
px = diff(p,x,1);
py = diff(p,y,1);
pz = diff(p,z,1);

Dp = [px;py;pz];



f = -mu*Deltau+Dp;
f = simplify(f);


sigman=(Eu-p*eye(3,3))*[0;0;1];
%subs(sigman,z,1)



