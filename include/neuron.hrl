-ifndef(NEURON).
-define(NEURON, true).

-record(neuron_data, {
    id :: integer(),        % unique identifier (for saving, loading and searching)

    %% for external services
    text :: string(),       % label text for APIs and other services (graphics, mobile apps etc.)
    
    % 3d koordináták
    x :: integer(),
    y :: integer(),
    z :: integer(),

    node :: [node()],  % melyik gépen fut

    %% data for worker node
    act :: float(),         % neuron activation threshold
    max :: float(),         % max value for activation threshold
    inputs :: integer(),    % number of inputs
    outputs :: [integer()], % list of neighbors to send outputs to
    activation :: atom()    % name of activation function
}).

-record(neuron_state, {
    % id :: integer(),        % unique identifier (for saving, loading and searching)
    
    data :: #neuron_data{}, % all the data that's also stored in db
    
    supervisor :: pid(),    % supervisor PID
    nbrs :: [pid()]         % list of neighbors (supervisor PIDs, only contains outputs)
    % buffer :: [float()],   % list of calculated inputs. wait for all inputs to calculate output value

    % activation :: atom()   % name of activation function
}).

-endif.
