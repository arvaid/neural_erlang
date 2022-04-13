% distribution of neurons across nodes

-type mapping() :: {integer(), node()}.

%% ezeket érdemes összevonni! overload

%% distribute all neurons in a system being created
-type init_strategy() :: fun(([integer()], [node()], [any()]) -> 
    [mapping()]).

%% add new neuron to the system
-type add_strategy() ::
    fun((integer(), [mapping()], [node()], [any()]) -> node()).
