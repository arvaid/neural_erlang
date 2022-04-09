%%% System supervisor
-module(system_sup).

%%% https://www.erlang.org/doc/man/supervisor.html

-behavior(supervisor).

-export([init/1]).
-export([start_link/1]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Args]).

init(Args) -> 
    system:init(Args).