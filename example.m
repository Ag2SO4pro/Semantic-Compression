%% Init data
load('example.mat')
%% Compression
[send,Oo,c]=semantic_compression(G,G_shared,1);