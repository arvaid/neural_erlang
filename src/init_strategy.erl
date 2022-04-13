%% Functions to describe the strategies for distributing neurons across a given set of Erlang nodes.
-module(init_strategy).

-export([equal_distribution/0]).

%% TODO: distribute nodes equally
equal_distribution() ->
    fun(Neurons, Nodes, _Args) -> 
        %% TODO: take first N neurons for each node
        NeuronsPerNode = length(Neurons) / length(Nodes),
        util:partition_list(Neurons, NeuronsPerNode)
    end.

%% TODO: other strategies:
%% - priority distribution
%% - random distribution
%% - custom distributor function (lambda)

% distribute neurons to nodes with a given set of priorities
% priority_distribution(Neurons, [{Node, Priority}, Nodes]) ->
%     NeuronCnt = length(Neurons),
%     NodeCnt = length(Nodes),
%     ok;
