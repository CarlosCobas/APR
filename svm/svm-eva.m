#!/usr/bin/octave -qf
addpath("matlab");
if (nargin!=7)
printf("Usage: svm-eva.m <trdata> <trlabels> <tedata> <telabels> <C> <T> <D>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
C=str2num(arg_list{5});
T=str2num(arg_list{6});
D=str2num(arg_list{7});


load(trdata);
load(trlabs);
load(tedata);
load(telabs);


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
                res = svmtrain(xl, X, args);

                [predicted_label, accr, dec]=svmpredict(yl,Y,res);
                err_mat=[err_mat; T(t),C(c),D(d),accr'];

                edv = 100 - accr'(1);

                m = edv / 100;
                s = sqrt(m*(1-m)/rows(Y));
                r = 1.96 * s;
                printf("I=[%.3f, %.3f]\n",m-r,m+r);
            end
        else
        
            args = char(["-t " , num2str(T(t)), " -c " , num2str(C(c))])
            res = svmtrain(xl, X, args);
            [predicted_label, accr, dec]=svmpredict(yl,Y,res);
            err_mat=[err_mat; T(t),C(c),D(d),accr'];
            
            edv = 100 - accr'(1);

            m = edv / 100;
			s = sqrt(m*(1-m)/rows(Y));
			r = 1.96 * s;
            printf("I=[%.3f, %.3f]\n",m-r,m+r);
        end
		
	end
    err_mat

end

save_precision(4); 
save("error_svm-eva.out", "err_mat");