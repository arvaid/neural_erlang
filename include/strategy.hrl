% distribution of neurons across nodes

-type neuron_list() :: [#neuron_data{}].
-type node_list() :: [node()].
-type arg_list() :: [any()].
-type mapping() :: {#neuron_data{}, node()}.

%% ezeket érdemes összevonni! overload

%% distribute all neurons in a system being created
-type init_strategy() :: fun((neuron_list(), node_list(), arg_list()) -> [mapping()]).

%% add new neuron to the system
-type add_strategy() ::
    fun((#neuron_data{}, neuron_list(), node_list(), arg_list()) -> node()).
