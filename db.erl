-module(db).

%% TODO: create fields
-record(neuron_state, {
    id :: integer(),
    text :: string(),
    data,
    state,
    activation :: float(),
    max :: float()
}).

-define(MYSQL_CONNSTR, "DSN=localhost;UID=erlang;PWD=password").

-export([create_schema/0, save/1, load/0, load/1]).

create_schema() -> 
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(neurons, [
        {type, set},
        {record_name, neuron_state},
        {attributes, record_info(fields, neuron_state)}
    ]),
    mnesia:stop().

save(#neuron_state{} = Record) ->
    SaveNeuron = fun() -> 
        mnesia:write(neurons, Record, write) 
    end,
    mnesia:activity(transaction, SaveNeuron).

load() -> 
    GetItems = fun() -> 
        Keys = mnesia:all_keys(neurons),
        lists:map(fun(Key) -> mnesia:read(neurons, Key) end, Keys) 
    end,
    mnesia:activity(sync_dirty, GetItems).

load(Key) ->
    GetItem = fun() -> mnesia:read(neurons, Key) end,
    mnesia:activity(sync_dirty, GetItem).
