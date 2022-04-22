
%%% Supervisor for neuron
-module(neuron_sup).

-behaviour(supervisor).

-include("neuron.hrl").

-export([init/1]).

-export([start_link/0]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    init(node());

init(Node) when is_atom(Node) ->
    % rpc:call(Node, ?MODULE, loop, [#neuron_state{}]).
    %% Node, M, F, A
    spawn(Node, ?MODULE, loop, [#neuron_state{}]).
