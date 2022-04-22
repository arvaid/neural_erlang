-module(test_distribution).

-include("system.hrl").
-include("neuron.hrl").

-export([test1/0, test2/0, test3/0, test4/0, test5/0]).

test1() ->
    system:create().

test2() ->
    system:create(#system_data{neurons = 
                                [#neuron_data{id = 1}, 
                                #neuron_data{id = 2}]}).

test3() ->
    system:create(#system_data{neurons = 
                                [#neuron_data{id = 1}, 
                                #neuron_data{id = 2}]},
                  [node1, node2]).

test4() ->
    system:create(#system_data{neurons =
                                   [#neuron_data{id = 1},
                                    #neuron_data{id = 2},
                                    #neuron_data{id = 3},
                                    #neuron_data{id = 4},
                                    #neuron_data{id = 5},
                                    #neuron_data{id = 6},
                                    #neuron_data{id = 7},
                                    #neuron_data{id = 8},
                                    #neuron_data{id = 9},
                                    #neuron_data{id = 10}]},
                  [node1, node2, node3, node4]).

test5() ->
    system:create(#system_data{neurons =
                                   [#neuron_data{id = 1},
                                    #neuron_data{id = 2},
                                    #neuron_data{id = 3}]},
                  [node1, node2, node3, node4]).
