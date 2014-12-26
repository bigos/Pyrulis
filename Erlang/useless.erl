-module(useless).
-export([add/2, hello/0, greet_and_add_two/1]).
-define(sub(X,Y), X-Y).
%% above line is an Erlang macro, similar to C #define
%% it replaces sub(X,Y) with X-Y before the code is being compiled

add(A,B) ->
    A + B.
 
%% Shows greetings.
%% io:format/1 is the standard function used to output text.
hello() ->
    io:format("Hello, world!~n").
 
greet_and_add_two(X) ->
    io:format("~nMacro example use ~p was given ~n",[?sub(67,1)]),
    hello(),
    add(X,2).
