function conditions=findP(P,index)
    dimensions=size(P);
    depth=length(dimensions);
    i=ones(1,depth-1);
    i=num2cell(i);
    conditions=ones(1,depth-1);
    conditions=conditions*-1;
    while(1)
        %% Counter
        for count=1:depth-1
            if i{count}>dimensions(count)
                i{count}=1;
                i{count+1}=i{count+1}+1;
            end
        end
       %[maxItem,maxIndex]=max(P(i{:},:));
       maxItem=-1;
       for k=1:dimensions(end)
           if P(i{:},k)>maxItem
               maxItem=P(i{:},k);
               maxIndex=k;
           elseif P(i{:},k)==maxItem
               maxIndex=-1;
           end
       end
       if (maxItem>0&&maxIndex==index)
           conditions=cell2mat(i);
           break;
       end
        %% Counter
        if all(cell2mat(i)==dimensions(1:depth-1))
            break;
        else
            i{1}=i{1}+1;
        end
    end
end