-module(activation).

-export([linear/1]).
-export([sigmoid/1]).
-export([tanh/1]).
-export([relu/1]).

-include("activation.hrl").

%%% https://www.geeksforgeeks.org/activation-functions-neural-networks/

-spec linear(number()) -> activation().
linear(A) when is_number(A) -> 
    % currying, mert 1 paraméteresnek kell lenni az aktivációs fv.-nek
    fun(X) when is_number(X) -> A * X end.

-spec sigmoid(number()) -> number().
sigmoid(X) when is_number(X) -> 1 / (1 + math:exp(-X)).

-spec tanh(number()) -> number().
tanh(X) when is_number(X) -> 2 - (1 + math:exp(-2 * X)) - 1.

-spec relu(number()) -> number().
relu(X) when is_number(X) -> max(0, X).
