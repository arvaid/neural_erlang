-module(db).

-include("neuron.hrl").

%% TODO: SQL compatibility
% -define(MYSQL_CONNSTR, "DSN=localhost;UID=erlang;PWD=password").

-export([create_schema/0]).
-export([save/1]). 
-export([load/0, load/1]).

-spec create_schema() -> any().
create_schema() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(neurons, [
        {type, set},
        {record_name, neuron_data},
        {attributes, record_info(fields, neuron_data)}
    ]),
    mnesia:stop().

save(#neuron_data{} = Record) ->
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
