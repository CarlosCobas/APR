addpath("matlab");
load ../data/mini/trSep.dat ; load ../data/mini/trSeplabels.dat
res = svmtrain(xl, X, '-t 0 -c 1000');

theta = res.sv_coef'*res.SVs;

theta0 = sign(res.sv_coef(1))-theta * res.SVs(1,:)';

tolerances = round(diag(1 - sign(res.sv_coef) * (theta * res.SVs' + theta0)) .* 100) / 100

x1 = [0:7];

x2 = -theta(1)/theta(2)*x1 - theta0/theta(2);

SV = X(res.sv_indices,:);
SVl = xl(res.sv_indices,:);


margin_total = 2/norm(theta);
margin = 1/norm(theta(2));

hf = figure();

plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"ob",x1,x2,"-k",SV(abs(fix(res.sv_coef)) < 1000,1),SV(abs(fix(res.sv_coef)) < 1000,2),"+k", "markersize", 12, SV(abs(fix(res.sv_coef)) == 1000,1),SV(abs(fix(res.sv_coef)) == 1000,2),"xk", "markersize", 12, x1, x2+margin, "-g", x1, x2-margin, "-b");
grid on;
text (0.5, 6.5, char(["marg = " , num2str(margin_total)]));

text (SV(:,1) + 0.1 ,SV(:,2)  + 0.1 , char(num2str(abs(fix(res.sv_coef)))));
text (SV(:,1) + 0.1 ,SV(:,2)  - 0.1 , char(num2str(tolerances)));

full(res.SVs)
full(res.SVs(1, :))

axis([0 7 0 7]);

set (hf, "visible", "off");
print(hf, "sepLineal.jpg", "-djpg");
