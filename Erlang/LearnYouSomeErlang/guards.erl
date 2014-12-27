%% FUNCTION GUARDS
-module(guards).
-compile(export_all). %% remember to replace with -export() later

%% this shows limits of pattern matching
%% old_enough(0) -> false;
%% old_enough(1) -> false;
%% old_enough(2) -> false;
%% ...
%% old_enough(14) -> false;
%% old_enough(15) -> false;
%% old_enough(_) -> true.


%% same as above but with guards
old_enough(X) when X >= 16 -> true;
old_enough(_) -> false.

%% Suppose we now forbid people who are over 104 years old to drive. 
%% Our valid ages for drivers is now from 16 years old up to 104 years old.
right_age(X) when X >= 16, X =< 104 -> % , used as and
true;
right_age(_) ->
false.
%% The comma (,) acts in a similar manner to the operator andalso and the semicolon
%% (;) acts a bit like orelse (described in "Starting Out (for real)"). Both guard
%%  expressions need to succeed for the whole guard to pass.
%% wrong_age(X) when X < 16; X > 104 -> % ; used as or
%% true;
%% wrong_age(_) ->
%% false.

