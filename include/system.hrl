-include("strategy.hrl").

-record(system_data, {
    neurons :: [integer()]  % neuron ids
}).

-record(system_state, {
    neurons :: [integer()],  % list of neurons in the system
    nextNeuronId :: integer(),
    % lambda                      % lambda function for custom behavior
    
    data :: #system_data{},
    mappings :: [{integer(), node()}],

    strategy :: init_strategy(),       % how to distributee neurons 
    args :: any()                 % extra arguments for strategy
}).