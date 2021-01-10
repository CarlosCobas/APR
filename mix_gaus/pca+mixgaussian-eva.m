#!/usr/bin/octave -qf

if (nargin!=6)
printf("Usage: pca+mixgaussian-eva.m <trdata> <trlabs> <tedata> <telabels> <ks> <alphas>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
ks=str2num(arg_list{5});
alphas=str2num(arg_list{6});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);


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
save("error_pca+mixgaussian-eva.out", "err_mat");