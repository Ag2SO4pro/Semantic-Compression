function P=getPMatrix(delta,Oo,G_shared,dimensions)
    depth=length(dimensions);
    i=ones(1,depth-1);
    i=num2cell(i);
    P=zeros(dimensions);
    while(1)
        %% Counter
        for count=1:depth-1
            if i{count}>dimensions(count)
                i{count}=1;
                i{count+1}=i{count+1}+1;
            end
        end
        %% Calculate P
        O_n=cell(1,depth);
        Ns=[];
        flag=0;
        for p=1:depth-1
            O_n{p}=Oo{p}(i{p},:);
            sample_s=[];
            for d=1:size(G_shared,1)
                if (strcmp(G_shared{d,1},O_n{p}{1})&&strcmp(G_shared{d,3},O_n{p}{3}))
                    for r=1:size(G_shared{d,2},1)
                        if (strcmp(G_shared{d,2}{r,1},O_n{p}{2}))
                            sample_s=G_shared{d,2}{r,2};
                            break;
                        end
                    end
                end
            end
            if (flag==0)
                Ns=sample_s;
                flag=1;
            else
                Ns=intersect(Ns,sample_s);
            end
        end
        sample_k=[];
        for r =1:size(delta{2},1)
            sample_k=union(sample_k,delta{2}{r,2});
            P(i{:},r)=length(intersect(delta{2}{r,2},Ns));
        end
        sample_k=intersect(sample_k,Ns);
        if sample_k~=0
            P(i{:},:)=P(i{:},:)/length(sample_k);
        else
            P(i{:},:)=0;
        end
        %% Counter
        if all(cell2mat(i)==dimensions(1:depth-1))
            break;
        else
            i{1}=i{1}+1;
        end
    end
end