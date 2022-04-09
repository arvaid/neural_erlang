-record(neuron_state, {
    id :: integer(),       % unique identifier (for saving and loading)
    
    %% for external services
    text :: string(),      % for APIs and other services (graphics, etc.)
    
    %% data for worker node
    act :: float(),        % neuron activation threshold
    max :: float(),        % max value for activation threshold
    
    %% internal use only, makes no sense to save it in db
    %% can i make it transient?
    supervisor :: pid(),   % supervisor PID

    % for both worker and supervisor
    buffer :: [float()],   % list of calculated inputs. wait for all inputs to calculate output value
    nbrs :: [pid()],       % list of neighbors (supervisor PIDs, only contains outputs)

    activation :: atom()   % name of activation function
}).
