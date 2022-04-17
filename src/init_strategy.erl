%% Functions to describe the strategies for distributing neurons across a given set of Erlang nodes.
-module(init_strategy).

-export([equal_distribution/0]).
-export([random_distribution/0]).

-include("neuron.hrl").

equal_distribution() ->
    fun (Neurons, Nodes, _Args) ->
        N = length(Neurons),
        M = length(Nodes),
        lists:zipwith(fun(Neuron, Index) ->
            if
                M > 1 -> {Neuron#neuron_data.id, lists:nth(Index div M + 1, Nodes)};
                M == 1 -> {Neuron#neuron_data.id, lists:nth(1, Nodes)}
            end
        end, Neurons, lists:seq(1, N))
    end.

%% TODO: other strategies:
%% - priority distribution

% distribute neurons to nodes with a given set of priorities
% priority_distribution(Neurons, [{Node, Priority}|Nodes]) ->
%     NeuronCnt = length(Neurons),
%     NodeCnt = length(Nodes),
%     ok;

random_distribution() ->
    fun (Neurons, Nodes, _Args) ->
        M = length(Nodes),
        lists:map(fun(Neuron) -> 
            {Neuron#neuron_data.id, lists:nth(rand:uniform(M), Nodes)}
        end, Neurons)
    end.
