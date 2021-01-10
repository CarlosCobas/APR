addpath("matlab");
load ../data/mini/trSep.dat ; load ../data/mini/trSeplabels.dat
res = svmtrain(xl, X, '-t 0 -c 1000');

theta = res.sv_coef'*res.SVs

theta0 = sign(res.sv_coef(1))-theta * res.SVs(1,:)'

x1 = [0:7]

x2 = -theta(1)/theta(2)*x1 - theta0/theta(2)

SV = X(res.sv_indices,:)
SVl = xl(res.sv_indices,:)


margin_total = 2/norm(theta)
margin = 1/norm(theta(2))

hf = figure();

plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"sb",x1,x2,"-k",SV(:,1),SV(:,2),"+r", x1, x2+margin, "-g", x1, x2-margin, "-b")
grid on
text (0.5, 6.5, char(["marg = " , num2str(margin_total)]));
axis([0 7 0 7])

set (hf, "visible", "off");
print(hf, "plot15_7.jpg", "-djpg");
