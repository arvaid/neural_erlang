-ifndef(SYSTEM).
-define(SYSTEM, 0).

-include("strategy.hrl").

%% replace this with the ETS table of neurons 
-record(system_data, {
    neurons :: [integer()]  % neuron ids
}).

%% system node state
-record(system_state, {
    neurons :: [integer()],  % list of neurons in the system
    nextNeuronId :: integer(),
    
    data :: #system_data{},
    mappings :: [{integer(), node()}],

    strategy :: init_strategy(),  % how to distribute neurons 
    args :: any()                 % extra arguments for strategy
}).
-endif.
