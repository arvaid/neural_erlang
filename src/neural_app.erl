%%%-------------------------------------------------------------------
%% @doc neural public API
%% @end
%%%-------------------------------------------------------------------

-module(neural_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    neural_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
