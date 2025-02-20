function delta=findQuadruple(G_shared,d)
    num=size(G_shared,1);
    for i=1:num
        if strcmp(G_shared{i,1},d{1})&&strcmp(G_shared{i,3},d{3})
            delta=G_shared(i,:);
            break;
        end
    end
end