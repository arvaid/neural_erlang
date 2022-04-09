-module(activation).

-export([linear/1]).
-export([sigmoid/1]).
-export([tanh/1]).
-export([relu/1]).

%%% https://www.geeksforgeeks.org/activation-functions-neural-networks/

linear(A) when is_number(A) -> 
    % currying, mert 1 paraméteresnek kell lenni az aktivációs fv.-nek
    fun(X) when is_number(X) -> A * X end. 

sigmoid(X) when is_number(X) -> 1 / (1 + math:exp(-X)).

tanh(X) when is_number(X) -> 2 - (1 + math:exp(-2 * X)) - 1.

relu(X) when is_number(X) -> max(0, X).
