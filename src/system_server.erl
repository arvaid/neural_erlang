%%% Module for starting the system
-module(system_server).

-include("system_state.hrl").
-include("neuron_state.hrl").

-export([init/0, init/1, init/2, init/3]).
-export([loop/1]).
-export([add_neuron/0, add_neuron/2]).
-export([delete_neuron/1]).
-export([stop/0]).
-export([restart/0]).

%% TODO: move init to supervisor
init() ->
    S = #system_state{neurons = [], nextId = 0},
    init(S).

init(#system_state{} = State) ->
    %% TODO: init the system on the current node with the given State
    %% ETS???
    register(system, spawn(?MODULE, loop, [State]));
init(Filename) ->
    %% TODO: init the system on the current node from the given file
    State = persistence:import_neurons(Filename),
    init(State).

init(#system_state{neurons = _N} = State, Nodes) when is_list(Nodes) ->
    % NeuronsPerNode = length(Nodes) / length(N),
    %% TODO: init the system on Nodes with the given State
    %% TODO: call system:init() on each of the nodes remotely
    % strategies:
    % - distribute equally
    % - distribute with a given set of priorities per server
    % - distribute randomly?
    {ok, State, Nodes};
init(Filename, Nodes) when is_list(Nodes) ->
    %% TODO: init the system on Nodes from the given file
    State = persistence:import_neurons(Filename),
    init(State, Nodes).

init(#system_state{} = State, Nodes, F) when is_list(Nodes), is_function(F) ->
    %% TODO: init the system on Nodes with the given State, with the given function F
    {ok, State, Nodes, F}; % tmp
init(Filename, Nodes, F) when is_list(Nodes), is_function(F) ->
    %% TODO: init the system on Nodes from the given file, with the given function F
    _State = persistence:import_neurons(Filename),
    {ok, Nodes, F}. % tmp

loop(#system_state{neurons = N} = State) ->
    receive
        {add_neuron, Inputs, Outputs, Sender} ->
            %% TODO: init neuron
            Neuron = #neuron_state{nbrs = Outputs},
            %% TODO: for all inputs, add the new neuron to nbrs
            lists:foreach(fun(I) -> extend_nbrs(I, Neuron) end, Inputs),
            S = State#system_state{neurons = lists:append(N, Neuron)},
            Sender ! {ok, add_neuron},
            loop(S);
        {delete_neuron, Id, Sender} ->
            {value, _, N1} = lists:keytake(Id, 1, N),
            S = State#system_state{neurons = N1},
            Sender ! {ok, delete_neuron},
            loop(S);
        {export, Filename, Sender} ->
            persistence:export_neurons(State, Filename),
            Sender ! {ok, export};
        {terminate, Sender} ->
            unregister(system),
            Sender ! {ok, terminate};
        _ ->
            loop(State)
    end.

extend_nbrs(Input, NewNbr) ->
    %% TODO: find neuron with Key=Input and add the new neuron to its nbrs list
    ok.

add_neuron() ->
    add_neuron([], []).

add_neuron(Inputs, Outputs) when is_list(Inputs), is_list(Outputs) ->
    system ! {add_neuron, Inputs, Outputs, self()}.

delete_neuron(Id) ->
    system ! {delete_neuron, Id, self()}.

stop() ->
    system ! {terminate, self()}.

restart() ->
    stop(),
    receive
        {ok, system} ->
            init(state)
    end.
