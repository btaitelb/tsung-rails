-module(tsung_rails).
-export([
  encoded_token/1,
  random/1
]).

random({_Pid, _DynData}) -> random_string(8).
random_string(N) -> random_seed(), random_string(N, []).
random_string(0, D) -> D;
random_string(N, D) ->
    random_string(N-1, [random:uniform(26)-1+$a|D]).
random_seed() ->
    {_,_,X} = erlang:now(),
    {H,M,S} = time(),
    H1 = H * X rem 32767,
    M1 = M * X rem 32767,
    S1 = S * X rem 32767,
    put(random_seed, {H1,M1,S1}).


encoded_token({_Pid, DynData}) ->
  {ok, Val} = ts_dynvars:lookup(authenticity_token, DynData),
  edoc_lib:escape_uri(Val).
