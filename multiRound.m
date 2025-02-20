function [Gn,On,conditions,Tn]=multiRound(Go,Oo,G_shared,n)
    num=size(Go,1);
    omit_num=0;
    send_num=0;
    On=cell(1,3);
    Gn=cell(1,3);
    Tn=0;
    conditions=cell(1,size(Oo,2));
    tic;
    for i=1:num
        delta=findQuadruple(G_shared,Go(i,:));% Curresponding quadruple
        dimensions=zeros(1,n);
        for j=1:n-1
            dimensions(j)=size(Oo{j},1);% The number of omitted triples
        end
        dimensions(n)=size(delta{2},1);% The number of relations for the current 2 entities
        P=getPMatrix(delta,Oo,G_shared,dimensions);
        index=-1;
        for r=1:size(delta{2},1)
            if strcmp(delta{2}{r},Go{i,2})
                index=r;
                break;
            end
        end
        c=findP(P,index);% Conditions: the indices of omitted triples
        %if strcmp(delta{2}{index,1},Go{num,2})
        if c(1)==-1
            send_num=send_num+1;
            [Gn{send_num,:}]=deal(Go{i,:});
        else
            omit_num=omit_num+1;
            [On{omit_num,:}]=deal(Go{i,:});
            conditions{omit_num}=c;
            dt=toc;
            Tn=Tn+dt;
            tic;
        end
    end
    dt=toc;
end