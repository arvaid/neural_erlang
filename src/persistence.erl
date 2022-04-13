%% save and load system state to/from files
-module(persistence).

-include("system.hrl").

-export([import_neurons/1, export_neurons/2]).

import_neurons(Filename) ->
    {ok, Txt} = file:read_file(Filename),
    Data = binary_to_term(Txt),
    Data#system_data{}.

export_neurons(#system_data{} = Data, Filename) ->
    Txt = term_to_binary(Data),
    {ok, File} = file:open(Filename, [write]),
    file:write(File, Txt).
