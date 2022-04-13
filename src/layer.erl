-module(layer).

%% TODO: make layer an optional feature
%% managing the network through layers is convenient, but we might also want to add neurons one by one

create(dense, N) when is_number(N) ->
    %% TODO: create dense layer with N number of neurons
    ok;

create(dropout, _) -> 
    %% TODO: create dropout layer
    ok.