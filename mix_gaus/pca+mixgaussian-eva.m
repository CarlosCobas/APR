#!/usr/bin/octave -qf

if (nargin!=7)
printf("Usage: pca+mixgaussian-eva.m <trdata> <trlabs> <tedata> <telabels> <pcaKs> <ks> <alphas>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
pcaKs=str2num(arg_list{5});
Ks=str2num(arg_list{6});
alphas=str2num(arg_list{7});


load(trdata);
load(trlabs);
load(tedata);
load(telabs);


[m W] = pca(X);

Xr = X - m;
Yr = Y - m;

err_mat = [];

for i=1:length(alphas)
	err_mat_a = [];
	for k=1:length(pcaKs)
		pcaXr = Xr * W(:,1:pcaKs(k));
		pcaYr = Yr * W(:,1:pcaKs(k));
		for j=1:length(Ks)
			edv = mixgaussian(pcaXr,xl,pcaYr,yl,Ks(j),alphas(i));

			m = edv / 100;
			s = sqrt(m*(1-m)/rows(pcaXr));
			r = 1.96 * s;


			printf("\n  alpha   PCA    K   dv-err");
			printf("\n  -----   ---   ---  ------\n");
			printf("  %.1e %3d  %3d  %6.3f\n\n",alphas(i),pcaKs(k),Ks(j),edv);
			printf("I=[%.3f, %.3f]\n",m-r,m+r);
			err_mat_a=[err_mat_a; alphas(i),pcaKs(k),Ks(j),edv];
		end
		
	end

	err_mat = [err_mat, err_mat_a];
end




save_precision(4); 
save("error_pca+mixgaussian-eva.out", "err_mat");