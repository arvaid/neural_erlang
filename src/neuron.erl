%%% A single neuron process
-module(neuron).

-include("neuron_state.hrl").

-export([init/1]).

init(#neuron_state{}) ->
    ok.
