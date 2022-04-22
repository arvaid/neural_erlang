-ifndef(SYSTEM).
-define(SYSTEM, true).

-include("strategy.hrl").

%% replace this with the ETS table of neurons 
-record(system_state, {
    neurons :: [integer()]  % neuron ids
}).

%% system node state
-record(system_sup_state, {
    neurons :: [integer()],  % list of neurons in the system
    nextNeuronId :: integer(),
    
    data :: #system_state{},
    mappings :: [{integer(), node()}], % which neurons are running on which node

    strategy :: init_strategy(),  % how to distribute neurons 
    args :: any()                 % extra arguments for strategy
}).
-endif.
