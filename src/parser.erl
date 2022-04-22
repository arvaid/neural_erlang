-module(parser).

-export([eval/1]).

-spec eval(string()) -> any().
%% TODO: refactor
eval(Expression) ->
    {ok, Tokens, _} = erl_scan:string(Expression),
    {ok, Parsed} = erl_parse:parse_exprs(Tokens),
    {value, Result, _} = erl_eval:exprs(Parsed, []),
    Result.
