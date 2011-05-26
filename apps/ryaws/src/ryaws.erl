%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 et
-module(ryaws).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0, stop/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    io:format(user, "ryaws:start_link/0~n", []),
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    io:format(user, "ryaws:stop/0~n", []),
    gen_server:cast(?SERVER, stop).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    io:format(user, "ryaws:init(~p)~n", [[]]),
    Self = self(),
    {ok, Self} = run().

handle_call(_Request, _From, State) ->
    {noreply, ok, State}.

handle_cast(stop, State) ->
    {stop, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

run() ->
    io:format(user, "ryaws:run/0~n", []),
    Id = "ryaws",
    GconfList = [{id, Id}],
    Docroot = "/tmp",
    SconfList = [{port, 8888},
                 {servername, "ryaws"},
                 {listen, {0,0,0,0}},
                 {docroot, Docroot}],
    {ok, SCList, GC, ChildSpecs} =
        yaws_api:embedded_start_conf(Docroot, SconfList, GconfList, Id),
    io:format(user, "            ChildSpecs:~p~n", [ChildSpecs]),
    [supervisor:start_child(ryaws_sup, Ch) || Ch <- ChildSpecs],
    yaws_api:setconf(GC, SCList),
    {ok, self()}.
