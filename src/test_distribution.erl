-module(test_distribution).

-include("system.hrl").
-include("neuron.hrl").

-export([test1/0, test2/0, test3/0, test4/0, test5/0]).

test1() ->
    system:create().

test2() ->
    system:create(#system_state{neurons = 
                                [#neuron_state{id = 1}, 
                                #neuron_state{id = 2}]}).

test3() ->
    system:create(#system_state{neurons = 
                                [#neuron_state{id = 1}, 
                                #neuron_state{id = 2}]},
                  [node1, node2]).

test4() ->
    system:create(#system_state{neurons =
                                   [#neuron_state{id = 1},
                                    #neuron_state{id = 2},
                                    #neuron_state{id = 3},
                                    #neuron_state{id = 4},
                                    #neuron_state{id = 5},
                                    #neuron_state{id = 6},
                                    #neuron_state{id = 7},
                                    #neuron_state{id = 8},
                                    #neuron_state{id = 9},
                                    #neuron_state{id = 10}]},
                  [node1, node2, node3, node4]).

test5() ->
    system:create(#system_state{neurons =
                                   [#neuron_state{id = 1},
                                    #neuron_state{id = 2},
                                    #neuron_state{id = 3}]},
                  [node1, node2, node3, node4]).
