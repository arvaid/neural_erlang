%%%-------------------------------------------------------------------
%% @doc neural top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(neural_sup).

-behaviour(supervisor).

-include("system.hrl").

-export([start_link/0, start_link/2, start_link/3]).
-export([init/1]).

-define(SERVER, ?MODULE).

%% empty network
start_link() ->
    % by default: empty network
    start_link([]).

start_link(Neurons) ->
    % by default: uses all known nodes
    start_link(Neurons, [node() | nodes()]).

start_link(Neurons, Nodes) ->
    % by default: distributed equally
    start_link(Nodes, Neurons, init_strategy:equal_distribution()).

start_link(Neurons, Nodes, DistributionStrategy) ->
    _Mappings = DistributionStrategy(Neurons, Nodes, []), % which neuron goes on which node
    State = #system_state{}, %% TODO: create system state
    supervisor:start_link({local, ?SERVER}, ?MODULE, [State]).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init(_State) ->
    SupFlags =
        #{strategy => one_for_one,
          intensity => 0,
          period => 1},
    ChildSpecs = [#{id => neuron, start => {neuron, start_link, []}}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
