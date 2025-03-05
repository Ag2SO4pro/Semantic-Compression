function [Gn,On,conditions,Tn]=multiRound(Go_,Oo,G_shared,n)
    Go=Go_;
    num=size(Go,1);
    omit_num=0;
    send_num=0;
    On=cell(1,3);
    Gn=cell(1,3);
    Tn=0;
    conditions=cell(1,n-1);
    have_updated=0;
    Oo_=cat(1,Oo{:});
    while(1)
        tic;
        for i=1:num
            delta=findQuadruple(G_shared,Go(i,:));
            comb=nchoosek(1:size(Oo_,1),n-1);
            P=getPMatrix(delta,Oo_,G_shared,comb);
            index=-1;
            for r=1:size(delta{2},1)
                if strcmp(delta{2}{r},Go{i,2})
                    index=r;
                    break;
                end
            end
            c=findP(P,index,comb);% Conditions: the indices of omitted triples
            %if strcmp(delta{2}{index,1},Go{num,2})
            if c(1)==-1
                send_num=send_num+1;
                [Gn{send_num,:}]=deal(Go{i,:});
            else
                have_updated=1;
                omit_num=omit_num+1;
                [On{omit_num,:}]=deal(Go{i,:});
                conditions{omit_num}=c;
                dt=toc;
                Tn=Tn+dt;
                tic;
            end
        end
        if have_updated==0
            break;
        end
        if isempty(Gn{1})
            break;
        end
        Oo_=[cat(1,Oo{:});On];
        Go=Gn;
        num=size(Go,1);
        send_num=0;
        Gn=cell(1,3);
        have_updated=0;
    end
    dt=toc;
end