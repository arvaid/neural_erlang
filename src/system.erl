%% cli interface for starting the system through system_sup
-module(system).

-include("system.hrl").
-include("neuron.hrl").

-export([init/1]).
-export([create/1, create/2, create/3, create/4]).
-export([add_neuron/0, add_neuron/2]).
-export([delete_neuron/1]).
% -export([add_layer/0]).
% -export([delete_layer/1]).
-export([restart/0]).
-export([stop/0]).

%% TODO: ETS???

%%% INIT
init(#system_state{} = S) ->
    register(system, self()),
    %% TODO: start child processes here, save PIDs in state, then start the loop
    loop(S).

%% start an empty network on the current node
create(empty) ->
    D = #system_data{neurons = []},
    create(D);
%% start network with the given structure on the current node
create(#system_data{} = Data) ->
    create(Data, [self()]);
%% same, but from file
create(Filename) ->
    create(Filename, [self()]).

%% start network with nodes distributed equally (default strategy)
create(#system_data{} = Data, Nodes) when is_list(Nodes) ->
    create(Data, Nodes, init_strategy:equal_distribution());
create(Filename, Nodes) when is_list(Nodes) ->
    create(Filename, Nodes, init_strategy:equal_distribution()).

% start network with nodes distributed according to the given strategy
create(#system_data{} = Data, Nodes, Strategy) ->
    create(Data, Nodes, Strategy, []);
create(Filename, Nodes, Strategy) ->
    create(Filename, Nodes, Strategy, []).

% start network with nodes distributed according to the given strategy
create(#system_data{} = Data, Nodes, Strategy, StrategyArgs) ->
    Neurons = Data#system_data.neurons,
    Mappings = Strategy(Neurons, Nodes, StrategyArgs), % which neuron goes on which node
    supervisor:start_link(?MODULE,
                          init,
                          [#system_state{data = Data,
                                         mappings = Mappings,
                                         strategy = Strategy,
                                         args = StrategyArgs}]);
create(Filename, Nodes, Strategy, StrategyArgs) ->
    Data = persistence:import_neurons(Filename),
    create(Data, Nodes, Strategy, StrategyArgs).

%%% END INIT

%%% LOOP
loop(#system_state{} = State) ->
    receive
        {add_neuron, Inputs, Outputs, Sender} ->
            %% TODO: init neuron
            Id = State#system_state.nextNeuronId,

            Neuron = #neuron_data{
                id = Id,
                outputs = Outputs},

            S = State#system_state{nextNeuronId=Id + 1},
                    % neurons=lists:append(L1, L2)}

            %% TODO: for all inputs, add the new neuron to nbrs
            %% TODO: find neuron with Key=Input and add the new neuron to its nbrs list
            % lists:foreach(fun(I) -> extend_nbrs(I, Neuron) end, Inputs),
            % S = State#system_state{neurons = lists:append(N, Neuron)},
            Sender ! {ok, add_neuron},
            loop(S);
        {delete_neuron, Id, Sender} ->
            % {value, _, N1} = lists:keytake(Id, 1, N),
            % S = State#system_state{neurons = N1},
            Sender ! {ok, delete_neuron};
            % loop(S);
        {export, Filename, Sender} ->
            persistence:export_neurons(State, Filename),
            Sender ! {ok, export};
        {terminate, Sender} ->
            unregister(system),
            Sender ! {ok, terminate, self()};
        _ ->
            loop(State)
    end.

%%% END LOOP

%%% API Functions
add_neuron() ->
    add_neuron([], []).

add_neuron(Inputs, Outputs) when is_list(Inputs), is_list(Outputs) ->
    system ! {add_neuron, Inputs, Outputs, self()}.

delete_neuron(Id) ->
    system ! {delete_neuron, Id, self()}.

% add_layer() -> ok.

% delete_layer(_Id) -> ok.

restart() ->
    stop(),
    receive
        {ok, system} ->
            init(state)
    end.

stop() ->
    system ! {terminate, self()}.%%% END API
