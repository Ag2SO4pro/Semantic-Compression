function conditions=findP(P,index,comb)
    dimensions=size(P);
    depth=size(comb,1);
    conditions=-1;
    for i=1:depth
       maxItem=-1;
       for k=1:dimensions(end)
           if P(i,k)>maxItem
               maxItem=P(i,k);
               maxIndex=k;
           elseif P(i,k)==maxItem
               maxIndex=-1;
           end
       end
       if (maxItem>0&&maxIndex==index)
           conditions=comb(i,:);
           break;
       end
    end
end