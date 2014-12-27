-module(functions).
-compile(export_all). %% remember to replace with -export() later

%% like lisp car
head([H|_]) -> H.

%% like lisp cadr
second([_,X|_]) -> X.

%% sameness
same(X,X) ->
true;
same(_,_) ->
false.

%% next to do is Guards
