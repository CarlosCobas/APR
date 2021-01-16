function [errY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden,epochs,show,seed)
    Xtr = Xtr'; xltr=xltr'; Xdv=Xdv'; xldv=xldv'; Y=Y'; yl=yl';

    yl = onehot(yl);
    xltr = onehot(xltr);
    [Xtrnorm,Xtrmean,Xtrstd] = prestd(Xtr);
    XdvNN.P = trastd(Xdv,Xtrmean,Xtrstd);
    XdvNN.T = onehot(xldv);
    
    initNN = newff(minmax(Xtrnorm),[nHidden 10], {"tansig","logsig"},"trainlm","","mse");
    
    initNN.trainParam.show = show;
    initNN.trainParam.epochs = epochs;  

    rand("seed",seed);
    NN = train(initNN,Xtrnorm,onehot(xltr),[],[],XdvNN);

    Ynorm = trastd(Y,Xtrmean,Xtrstd);
    Yout = sim(NN,Ynorm);
    
    predictedLabels = [];
    for c = 1: rows(Yout')
        [value, index] = max(Yout(:,c));
        predictedLabels = [predictedLabels;index-1];
    end
    errY = mean(xldv!=predictedLabels)*100;

end

    