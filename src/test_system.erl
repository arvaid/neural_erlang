-module(test_system).

-export([test/0]).

test() -> 
    system:create().