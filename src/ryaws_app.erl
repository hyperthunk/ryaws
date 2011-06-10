%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 et
-module(ryaws_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    io:format(user, "ryaws_app:start/0~n", []),
    ryaws_sup:start_link().

stop(_State) ->
    io:format(user, "ryaws_app:stop/0~n", []),
    ok.
