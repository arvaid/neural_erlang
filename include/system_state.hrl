-record(system_state, {
    neurons :: [neuron_state],  % list of neurons in the system
    nextId :: integer(),         % 
    lambda                      % lambda function for custom behavior
}).