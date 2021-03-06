#!/usr/bin/octave -qf

if (nargin!=7)
printf("Usage: pca+mixgaussian-exp.m <trdata> <trlabels> <pcaKs> <Ks> <alphas> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
pcaKs=str2num(arg_list{3});
Ks=str2num(arg_list{4});
alphas=str2num(arg_list{5});
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


[m W] = pca(Xtr);

Xtr = Xtr - m;
Xdv = Xdv - m;

err_mat = [];

for i=1:length(alphas)
	err_mat_a = [];
	for k=1:length(pcaKs)
		pcaXtr = Xtr * W(:,1:pcaKs(k));
		pcaXdv = Xdv * W(:,1:pcaKs(k));
		for j=1:length(Ks)
			edv = mixgaussian(pcaXtr,xltr,pcaXdv,xldv,Ks(j),alphas(i));
			printf("\n  alpha   PCA    K   dv-err");
			printf("\n  -----   ---   ---  ------\n");
			printf("  %.1e %3d  %3d  %6.3f\n\n",alphas(i),pcaKs(k),Ks(j),edv);
			err_mat_a=[err_mat_a; alphas(i),pcaKs(k),Ks(j),edv];
		end
		
	end

	err_mat = [err_mat, err_mat_a];
end

save_precision(4); 
save("error_pca+mixgaussian-exp.out", "err_mat");