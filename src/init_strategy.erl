%% Functions to describe the strategies for distributing neurons across a given set of Erlang nodes.
-module(init_strategy).

-export([equal_distribution/0]).

% example_strategy(Neurons, Nodes, _Args) ->
%     lists:zip(Neurons, Nodes).

%% TODO: distribute nodes equally
equal_distribution() ->
    fun(Layers, Nodes, _Args) -> 
        %% TODO: take first N neurons for each node
    
    
        % NeuronsPerNode = length(Layers) / length(Nodes),
        % NeuronCntForEachNode = util:partition_list(Neurons, NeuronsPerNode),
        % Pairs = lists:zip(NeuronCntForEachNode, Nodes),
        ok
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
