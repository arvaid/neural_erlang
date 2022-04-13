-include("layer.hrl").
-include("strategy.hrl").

-record(system_data, {
    layers :: [#layer_data{}]
}).

-record(system_state, {
    layers :: [#layer_state{}],  % list of neurons in the system
    nextLayerId :: integer(),     
    nextNeuronId :: integer(),
    % lambda                      % lambda function for custom behavior
    
    data :: #system_data{},
    mappings :: [{#neuron_data{}, node()}],

    strategy :: init_strategy(),       % how to distributee neurons 
    args :: any()                 % extra arguments for strategy
}).