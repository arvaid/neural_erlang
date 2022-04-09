%%% Supervisor for neuron
-module(neuron_sup).

-behavior(supervisor).

-export([init/1]).
-export([start_link/1]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Args]).

init(Args) -> 
    neuron:init(Args).
