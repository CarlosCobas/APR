#!/usr/bin/octave -qf
addpath("matlab");
if (nargin!=7)
printf("Usage: pca+mixgaussian-exp.m <trdata> <trlabels> <C> <T> <D> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
C=str2num(arg_list{3});
T=str2num(arg_list{4});
D=str2num(arg_list{5});
trper=str2num(arg_list{6});
dvper=str2num(arg_list{7});

load(trdata);
load(trlabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);


% [m W] = pca(Xtr);

% Xtr = Xtr - m;
% Xdv = Xdv - m;

err_mat = [];

for t=1:length(T)
	err_mat_a = [];
	for c=1:length(C)
		% pcaXtr = Xtr * W(:,1:pcaKs(k));
		% pcaXdv = Xdv * W(:,1:pcaKs(k));
		if(T(t) == 1)
            for d=1:length(D)

                args = char(["-t " , num2str(T(t)), " -c " , num2str(C(c)), " -d " ,num2str(D(d))])
                res = svmtrain(xltr, Xtr, args);

                [predicted_label, accr, dec]=svmpredict(xldv,Xdv,res);
                err_mat=[err_mat; T(t),C(c),D(d),accr'];
            end
        else
        
            args = char(["-t " , num2str(T(t)), " -c " , num2str(C(c))])
            res = svmtrain(xltr, Xtr, args);
            [predicted_label, accr, dec]=svmpredict(xldv,Xdv,res);
            err_mat=[err_mat; T(t),C(c),D(d),accr'];
            
        end
		
	end
    err_mat

end

save_precision(4); 
save("error_svm-exp.out", "err_mat");