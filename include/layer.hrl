-include("neuron.hrl").

-record(layer_data, {
    inputs_shape :: integer(),  % size of input vector
    neurons :: [#neuron_data{}],
    neuron_count :: integer(),  % number of neurons in current layer
    output_shape :: integer(),  % size of output vector
    next_layer :: integer()     % id of next layer
}).

-record(layer_state, {
    next_layer_sup :: pid(),    % pid of next layer supervisor
    %% TODO: select data type for buffer. maybe a map?
    input_buffer :: [{integer(), float()}],  % for collecting inputs before forwarding to next layer
    data :: #layer_data{}       % structural definitions
}).
