
%Eg 1
%calculate the pde 
%[0,1]^3
% u = 0 on \partial\Omega



syms x y z mu

 %u =  [sin(x)*cos(y)*exp(z);...
 %      exp(x+y)*cos(z);...
 %      sin(x)*sin(y)*exp(z)];
 %p = exp(x+y+z);

%ou = [y^2*(1-y)^2*x*(1-x)*z^2*(1-z)^3;x^2*(1-x)^2*y*(1-y)*z^2*(1-z)^3;0];
%u = simplify(curl(ou,[x y z]));


%% 
u =[-x^2*y*z*(5*z - 2)*(x - 1)^2*(y - 1)*(z - 1)^2
    x*y^2*z*(5*z - 2)*(x - 1)*(y - 1)^2*(z - 1)^2
    4*x*y*z^2*(x - y)*(x - 1)*(y - 1)*(z - 1)^3];

p = (x-1/2)*(y-1/2)*(1-z);

%%
%grad
%Du is a tensor 
ux = diff(u(:,1),x,1);
uy = diff(u(:,1),y,1);
uz = diff(u(:,1),z,1);

Du = [ux,uy,uz];

Deltau = diff(Du(:,1),x,1)+diff(Du(:,2),y,1)+diff(Du(:,3),z,1);



%Dp  is a vector 
px = diff(p,x,1);
py = diff(p,y,1);
pz = diff(p,z,1);

Dp = [px;py;pz];



f = -mu*Deltau+Dp;
f= simplify(f);






