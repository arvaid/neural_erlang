-module(db).

-include("neuron.hrl").

-export([start/1, stop/1]).
-export([create_schema/1]).
-export([save/2, save/3]). 
-export([load/2, load/3]).
-export([load_all/1, load_all/2]).

-spec create_schema('mnesia') -> any().

start(mnesia) ->
    mnesia:start();
start(mysql) ->
    {ok, Pid} = mysql:start_link([{host, "localhost"},
                      {user, "erlang"},
                      {password, "password"},
                      {database, "erlang_neural"}
                    ]),
    register(mysql, Pid).

stop(mnesia) ->
    mnesia:stop();
stop(mysql) ->
    mysql:stop(whereis(mysql)).

create_schema(mnesia) ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(neurons, [
        {type, set},
        {record_name, neuron_state},
        {attributes, record_info(fields, neuron_state)}
    ]),
    mnesia:stop();
create_schema(mysql) ->
    {ok, Text} = file:read_file(<<"init.sql">>),
    Stmts = binary:split(Text, <<";">>, [trim, global]),
    Pid = whereis(mysql),
    mysql:transaction(Pid, fun() ->
        lists:foreach(fun(Stmt) ->
                % Replaced = re:replace(Stmt, "\n+ *", "", [{return, list}, global]),
                % io:format("~p~n", [Replaced])
                mysql:query(Pid, Stmt)
             end, Stmts)
        end).

save(mnesia, #neuron_state{} = Record) ->
    SaveNeuron = fun() -> 
        mnesia:write(neurons, Record, write)
    end,
    mnesia:activity(transaction, SaveNeuron).

save(mysql, neuron, Record) ->
    Pid = whereis(mysql),
    mysql:transaction(Pid, fun() ->
        ok = mysql:query(Pid, 
            "INSERT INTO Neuron " ++
            "(id, label, node, code, is_started, is_busy, x,y,z, value, activation_value) " ++
            "VALUES(?, ?, ?, ?, ?, ?, ?,?,?, ?, ?)",
            [Record#neuron_state.id, 
             Record#neuron_state.label, 
             Record#neuron_state.node,
             Record#neuron_state.code,
             Record#neuron_state.is_started,
             Record#neuron_state.is_busy,
             Record#neuron_state.x, Record#neuron_state.y, Record#neuron_state.z,
             Record#neuron_state.value,
             Record#neuron_state.activation_value])
    end).

load_all(mnesia) -> 
    GetItems = fun() ->
        Keys = mnesia:all_keys(neurons),
        lists:map(fun(Key) -> mnesia:read(neurons, Key) end, Keys) 
    end,
    mnesia:activity(sync_dirty, GetItems).

load_all(mysql, Table) ->
    Pid = whereis(mysql),
    {ok, Result} = mysql:query(Pid, "SELECT * FROM ?", [Table]),
    Result.

load(mnesia, Key) ->
    GetItem = fun() -> mnesia:read(neurons, Key) end,
    mnesia:activity(sync_dirty, GetItem).

load(mysql, Table, Key) ->
    Pid = whereis(mysql),
    {ok, Result} = mysql:query(Pid, "SELECT * FROM ? WHERE id = ?", [Table, Key]),
    Result.
