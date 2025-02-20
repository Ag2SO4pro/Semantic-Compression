function [send,omit,conditions]=semantic_compression(G,G_shared,paint,max_round)
    if nargin==2
        max_round=+inf;
        paint=0;
    elseif nargin==3
        max_round=+inf;
    end
    if isinf(max_round)
        times=[];
        omit_num=[];
        conditions={};
    else
        times=zeros(1,max_round);
        omit_num=zeros(1,max_round);
        conditions=cell(1,max_round-1);
    end
    reach_count=0;
   [G1,O1,M1,T1]=firstRound(G,G_shared);
    times(1)=T1;
    reach_count=reach_count+1;
    omit_num(1)=size(O1,1);
    omit={O1};
    Go=G1;
    if max_round>=2
        %% >=2 Round
        i=2;
        while(1)
            [Gn,On,c,Tn]=multiRound(Go,omit,G_shared,i);
            times(i)=Tn;
            if length(On)>1&&~isempty(On{1,1})
                omit_num(i)=size(On,1);
                omit{i}=On;
                conditions{i-1}=c;
            end
            Go=Gn;
            if isempty(On{1,1})||length(On)<1
                break;
            end
            reach_count=reach_count+1;
            if length(Go)<1||isempty(Go{1,1})
                break;
            end
            if i==max_round
                break;
            end
            i=i+1;
        end
    end
    send=[Gn(:,:);M1(:,:)];
    send(cellfun(@isempty,send))=[];
    if paint
    %% Plot
        rho=[];
        rho(1)=1;
        total=size(G,1);
        left=total;
        for r=1:reach_count
            left=left-omit_num(r);
            rho(r+1)=left/total;
        end
        rho=fliplr(rho(1:reach_count+1));
        times_=fliplr([0,times(1:reach_count)]);
        for i= reach_count:-1:1
            times_(i)=times_(i+1)+times_(i);
        end
        figure(1);
        for k=1:reach_count
            plot(rho(k:k+1),times_(k:k+1),'-','LineWidth',1.5);
            hold on;
        end
        xlabel('Ratio of remained triples');
        ylabel('Run time(s)'); 
    end
end