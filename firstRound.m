% First round of compression
function [G1,O1,M1,T1]=firstRound(G,G_shared)
    % Initialize
    num_G=size(G,1);
    num_Gs=size(G_shared);
    omit_num=0;
    send_num=0;
    must_num=0;
    O1=cell(1,3);
    G1=cell(1,3);
    M1=cell(1,3);
    T1=0;
    tic;
    % Go over all triples to be sent and compare with 
    % existing quadruples
    for i=1:num_G
        isOmit=0;
        must=0;
        same=0;
        for j=1:num_Gs
            if strcmp(G{i,1},G_shared{j,1})&&strcmp(G{i,3},G_shared{j,3})
                same=1;
                num_r=size(G_shared{j,2},1);
                index=-1;
                max_r=0;
                max_sam_num=-1;
                for r=1:num_r
                    if strcmp(G_shared{j,2}{r,1},G{i,2})
                        index=r;
                    end
                    if length(G_shared{j,2}{r,2})>max_sam_num
                        max_r=r;
                        max_sam_num=length(G_shared{j,2}{r,2});
                    end
                end
                if index==-1
                    % Relation not exists
                    % Must be sent
                    must=1;
                    must_num=must_num+1;
                    [M1{must_num,:}]=deal(G{i,:});
                    break;
                end
                if max_r==index
                    % Current relation has the largest probability
                    omit_num=omit_num+1;
                    [O1{omit_num,:}]=deal(G{i,:});
                    isOmit=1;
                    dt=toc;
                    T1=T1+dt;
                    tic;
                    break;
                end
            end
            if isOmit==1||must==1
                break;
            end
        end
        if same==0
            % No same head-tail entity pairs
            % Must be sent
            must=1;
            must_num=must_num+1;
            [M1{must_num,:}]=deal(G{i,:});
        end
        if isOmit~=1&&must~=1
            send_num=send_num+1;
            [G1{send_num,:}]=deal(G{i,:});
        end
    end
    dt=toc;
end