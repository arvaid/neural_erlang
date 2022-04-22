%% Functions to describe the strategies for distributing neurons across a given set of Erlang nodes.
-module(init_strategy).

-export([equal_distribution/0]).
-export([random_distribution/0]).

-include("neuron.hrl").

%% distribute neurons equally among nodes (if possible)

% TODO: optimize this function to use the lists module less
equal_distribution() ->
    fun (Neurons, Nodes, _Args) ->
        N = length(Neurons),
        M = length(Nodes),
        Ids = lists:map(fun(Neuron) -> Neuron#neuron_state.id end, Neurons),
        if 
            N == 0 -> [];
            M == 0 -> bad_arg;
            N == M -> lists:zip(Ids, Nodes);
            N > M, M > 1 -> lists:zipwith(fun(Id, Index) -> {Id, lists:nth((Index div M) + 1, Nodes)} end, Ids, lists:seq(1, N));
            N > M, M == 1 -> lists:map(fun(Id) -> {Id, lists:nth(1, Nodes)} end, Ids);
            N > M, M < 1 -> bad_arg;
            N < M -> lists:zipwith(fun(Id, Index) -> {Id, lists:nth(M - (M div Index)+1, Nodes)} end, Ids, lists:seq(1, N))
        end
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
            {Neuron#neuron_state.id, lists:nth(rand:uniform(M), Nodes)}
        end, Neurons)
    end.
