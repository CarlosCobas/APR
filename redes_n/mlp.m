function [errY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden,epochs,show,seed)
    Xtr = Xtr'; xltr=xltr'; Xdv=Xdv'; xldv=xldv'; Y=Y'; yl=yl';

    yl = onehot(yl);
    xldv = onehot(xldv);
    xltr = onehot(xltr);

    //TODO: Obtencion de clase estimada a partir de funcion sim y estimación de error para devolver errY
    