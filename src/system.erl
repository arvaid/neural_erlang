%% TODO: move all of this code into the neural module, or into its supervisor

%% cli interface for starting the system through neural_sup
-module(system).

-include("system.hrl").

-export([init/1]).
-export([create/0, create/1, create/2, create/3, create/4]).
-export([add_neuron/0, add_neuron/2]).
-export([delete_neuron/1]).
-export([restart/0]).
-export([stop/0]).

%% TODO: ETS???

%%% INIT
init(#system_sup_state{} = S) ->
    register(neural, self()),
    %% TODO: start child processes here, save PIDs in state, then start the loop
    loop(S).

%% start an empty network on the current node
create() ->
    D = #system_state{neurons = []},
    create(D).

%% start network with the given structure on the currently available nodes
create(#system_state{} = Data) ->
    create(Data, [node()|nodes()]);
%% same, but from file
create(Filename) ->
    create(Filename, [node()|nodes()]).

%% start network with nodes distributed equally (default strategy)
create(#system_state{} = Data, Nodes) when is_list(Nodes) ->
    create(Data, Nodes, init_strategy:equal_distribution());
create(Filename, Nodes) when is_list(Nodes) ->
    create(Filename, Nodes, init_strategy:equal_distribution()).

% start network with nodes distributed according to the given strategy
create(#system_state{} = Data, Nodes, Strategy) ->
    create(Data, Nodes, Strategy, []);
create(Filename, Nodes, Strategy) ->
    create(Filename, Nodes, Strategy, []).

% start network with nodes distributed according to the given strategy
create(#system_state{} = Data, Nodes, Strategy, StrategyArgs) ->
    Neurons = Data#system_state.neurons,
    Mappings = Strategy(Neurons, Nodes, StrategyArgs), % which neuron goes on which node
    lists:foreach(fun({NeuronId, Node}) ->
        N = Data#system_state.neurons,
        D = lists:keyfind(NeuronId, 2, N),
        %% TODO: use supervisor instead
        spawn(Node, neuron, init, [D])
    end, Mappings);
    % supervisor:start_link(?MODULE,
    %                       init,
    %                       [#system_sup_state{data = Data,
    %                                      mappings = Mappings,
    %                                      strategy = Strategy,
    %                                      args = StrategyArgs}]);
create(Filename, Nodes, Strategy, StrategyArgs) ->
    Data = persistence:import_neurons(Filename),
    create(Data, Nodes, Strategy, StrategyArgs).

%%% END INIT

%%% LOOP
loop(#system_sup_state{} = State) ->
    receive
        {add_neuron, _Inputs, _Outputs, Sender} ->
            %% TODO: init neuron
            Id = State#system_sup_state.nextNeuronId,

            % Neuron = #neuron_state{
            %     id = Id,
            %     outputs = Outputs},

            S = State#system_sup_state{nextNeuronId=Id + 1},
                    % neurons=lists:append(L1, L2)}

            %% TODO: for all inputs, add the new neuron to nbrs
            %% TODO: find neuron with Key=Input and add the new neuron to its nbrs list
            % lists:foreach(fun(I) -> extend_nbrs(I, Neuron) end, Inputs),
            % S = State#system_sup_state{neurons = lists:append(N, Neuron)},
            Sender ! {ok, add_neuron},
            loop(S);
        {delete_neuron, _Id, Sender} ->
            % {value, _, N1} = lists:keytake(Id, 1, N),
            % S = State#system_sup_state{neurons = N1},
            Sender ! {ok, delete_neuron};
            % loop(S);
        {export, Filename, Sender} ->
            persistence:export_neurons(State, Filename),
            Sender ! {ok, export};
        {terminate, Sender} ->
            unregister(neural),
            Sender ! {ok, terminate, self()};
        _ ->
            loop(State)
    end.

%%% END LOOP

%%% API Functions
add_neuron() ->
    add_neuron([], []).

add_neuron(Inputs, Outputs) when is_list(Inputs), is_list(Outputs) ->
    neural ! {add_neuron, Inputs, Outputs, self()}.

delete_neuron(Id) ->
    neural ! {delete_neuron, Id, self()}.

% add_layer() -> ok.

% delete_layer(_Id) -> ok.

restart() ->
    stop(),
    receive
        {ok, system} ->
            init(state)
    end.

stop() ->
    neural ! {terminate, self()}.
    
%%% END API

