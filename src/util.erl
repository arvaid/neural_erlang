-module(util).

-export([partition_list/2]).

% divide a list into equal parts 
partition_list([], _) -> [];
partition_list(List, Len) when Len > length(List) ->
    [List];
partition_list(List, Len) ->
    {Head,Tail} = lists:split(Len, List),
    [Head | partition_list(Tail, Len)].

%% TODO: algorithm for prioritized distribution of neurons
%% also see distribution_strategy.erl
% partition_list(List, Priorities, NodeCnt) ->
%     partition_list(List, Priorities, NodeCnt, []).
% partition_list([], Priorities, NodeCnt, Acc) ->
%     Acc;
% partition_list([H], Priorities, NodeCnt, Acc) ->
%     Acc 
% partition_list(List, [P|Priorities], NodeCnt, Acc) ->
