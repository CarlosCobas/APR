function [errY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden,epochs,show,seed)
    Xtr = Xtr'; xltr=xltr'; Xdv=Xdv'; xldv=xldv'; Y=Y'; yl=yl';
    
    [Xtrnorm,Xtrmean,Xtrstd] = prestd(Xtr);
    XdvNN.P = trastd(Xdv,Xtrmean,Xtrstd);
    XdvNN.T = onehot(xldv);
    
    classes=unique(yl);
    C=length(classes);

    initNN = newff(minmax(Xtrnorm),[nHidden C], {"tansig","logsig"},"trainlm","","mse");
    
    initNN.trainParam.show = show;
    initNN.trainParam.epochs = epochs;  

    rand("seed",seed);
    NN = train(initNN,Xtrnorm,onehot(xltr),[],[],XdvNN);

    Ynorm = trastd(Y,Xtrmean,Xtrstd);
    Yout = sim(NN,Ynorm);
    
    predictedLabels = [];
    for c = 1: rows(Yout')
        [value, index] = max(Yout(:,c));
        predictedLabels = [predictedLabels;index];
    end
    errY = mean(yl'!=predictedLabels)*100;
    yl'
end

    