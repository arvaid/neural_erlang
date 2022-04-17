-ifndef(NEURON).
-define(NEURON, true).

%% save into ETS
-record(neuron_data, {
    id :: integer(),        % unique identifier (for saving, loading and searching)
    %% for external services
    label :: string(),       % label text for APIs and other services (graphics, mobile apps etc.)

    % 3d koordináták
    x :: integer(),
    y :: integer(),
    z :: integer(),    

    %% data for worker node
    code :: binary(),
    is_started :: boolean(),
    is_busy :: boolean(),
    value :: float(),            % neuron activation threshold
    activation_value :: float(), % max value for activation threshold
    % inputs :: integer(),    % number of inputs

    % data for supervisor
    node :: [node()],  % melyik gépen fut
    outputs :: [integer()]       % list of neighbors to send outputs to

}).

%% supervisor state
-record(neuron_state, {
    data :: #neuron_data{}, % all the data that's also stored in db
    
    supervisor :: pid(),    % supervisor PID
    nbrs :: [pid()],         % list of neighbors (supervisor PIDs, only contains outputs)
    % buffer :: [float()],   % list of calculated inputs. wait for all inputs to calculate output value

    func
}).

-endif.
