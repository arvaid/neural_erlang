-module(persistence).

-include("system_state.hrl").

-export([import_neurons/1, export_neurons/2]).

import_neurons(Filename) ->
    {ok, Txt} = file:read_file(Filename),
    Neurons = binary_to_term(Txt),
    #system_state{neurons = Neurons}.

export_neurons(#system_state{neurons = N}, Filename) ->
    Txt = term_to_binary(N),
    {ok, File} = file:open(Filename, [write]),
    file:write(File, Txt).