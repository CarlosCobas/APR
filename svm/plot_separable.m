addpath("matlab");
load ../data/mini/trSep.dat ; load ../data/mini/trSeplabels.dat
res = svmtrain(xl, X, '-t 0 -c 1000');

theta = res.sv_coef'*res.SVs
theta0 = sign(res.sv_coef(1))-theta * res.SVs(1,:)'
x1 = [0:7]
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2)
SV = X(res.sv_indices,:)
hf = figure();
plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"sb",x1,x2,"-k",SV(:,1),SV(:,2),"+r")

set (hf, "visible", "off");
print(hf, "plot15_7.pdf",-djpg);
