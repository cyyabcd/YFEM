

clear
clc


pde=example2;

box = [0,1,0,1,0,1];
h = 1;
[node,elem,HB] = cubemesh(box,h);
fp = -pde.f(node,1);
u=pde.exactu(node);
exactp=pde.exactpressure(node);
Eu = pde.Eu(node);