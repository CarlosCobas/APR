#!/usr/bin/octave -qf
addpath("nnet_apr");
if (nargin!=6)
printf("Usage: mlp-exp.m <trdata> <trlabels> <nHiddens> <pcaKs> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
nHiddens=str2num(arg_list{3});
pcaKs=str2num(arg_list{4});
trper=str2num(arg_list{5});
dvper=str2num(arg_list{6});

load(trdata);
load(trlabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);

[m W] = pca(Xtr);

Xtr = Xtr - m;
Xdv = Xdv - m;


printf("\n nH dv-err");
printf("\n--- ------\n");

show=10;
epochs=300;
err_mat= [];

for i=1:length(nHiddens)

  	err_mat_a = [];
	  
	for k=1:length(pcaKs)
		pcaXtr = Xtr * W(:,1:pcaKs(k));
		pcaXdv = Xdv * W(:,1:pcaKs(k));

        edv = mlp(pcaXtr,xltr,pcaXdv,xldv,pcaXdv,xldv,nHiddens(i),epochs,show,seed);
        printf("%3d %3d %6.3f\n",nHiddens(i), pcaKs(k),edv);
        err_mat_a=[err_mat_a; nHiddens(i),pcaKs(k),edv];
		
	end

	err_mat = [err_mat, err_mat_a];
end

save_precision(4); 
save("error_pca+mlp-exp.out", "err_mat");