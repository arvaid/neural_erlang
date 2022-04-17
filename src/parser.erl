-module(parser).

-export([eval/1]).

%% https://grantwinney.com/how-to-evaluate-a-string-of-code-in-erlang-at-runtime/
-spec eval(string()) -> any().
eval(Expression) ->
    {ok, Tokens, _} = erl_scan:string(Expression),
    {ok, Parsed} = erl_parse:parse_exprs(Tokens),
    {value, Result, _} = erl_eval:exprs(Parsed, []),
    Result.
