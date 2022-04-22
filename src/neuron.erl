%%% A single neuron process
-module(neuron).

%% TODO: int küszöb, int aktuális
%% üzenetkor aktuális++, küszöböt eléri -> output
%% lambda fv.
%% milyen számot küld el?
%% kommunikáció: supervisoron át

%% sup. funkciók:
%% tárolja a küszöb értéket (induláskor, v. valamikor megkapja)
%% tárolja az aktuális feszültségszintet
%% tárolja a szomszédoknak elküldendő értéket
%% tevékenyen várakozik
%% induláskor elindítja a worker node-t (szintén vár)
%% (ETS tábla létrehozás)

sup_start(State) ->
    W_Id = start_worker(),
    ETS_Id = create_ets(),
    %% State-hez hozzáadjuk az Id-kat

    %% szomszédok beállítása:
    State1 = set_nbrs(State, []),
    start_sup_loop(State1).

%% TODO: Dolgozatba beírni a protokollt
%% később, ha több kérés jön, tudjon új workereket  csinálni, nyilvántartja ki mit csinál, ki kérte, stb.

sup_loop(State) ->
    receive
        {Pid, Func, Args} ->
            %% Func beszúrása táblába, legutljára ezen dolgozott
            State#W_Id ! {self(), Func, Args},
            %% vissza kellene jelezni a Pid-nek
            Pid ! ok,
            %% Pid eltárolása
            sup_loop(State);
        {State#W_Id, Result} ->
            %% törli a Func-ot
            %% TODO: logfile (később)
            handle_result(Result), % log file
            sup_loop(State);
        {Pid, restart} ->
            save_state(State),
            % handle_restart(), % indítsa újra a workert
            kill(W_Id),
            W_Id = start_worker(State),
            %% ETS törlés
            ETS_Id = create_ets(),
            sup_loop(State);
        {Pid, set_nbrs, PidList} ->
            % saját Id-t ne fogadja el !
            State1 = set_nbrs(State, Pid_list),
            sup_loop(State1);
        {Pid, incr, Num} ->
            % feszültségszint emelése
            % ha eléri a küszöbszámot, elküldi az osszes szomszédnak

            %% Jelenlegi helyzetben: küldés elött teszteli, hogy letezik-e? (SQL-ben is és Pid alapján is)
            %State1 = lists:foreach(fun, PidList),
            % feszültség nullázás
            sup_loop(State);
        {Pid, setParams, {Feszultseg, Threshold, SendData}} ->
            State = handle_set(Feszultseg, Threshold, SendData),
            sup_loop(State);
        {Pid, checkNbrs} ->
            %% végignézi, a szomszédai léteznek-e?
            %% amelyik nem, azt törli
            %% try-catch
            sup_loop(State);
        {Pid, check} ->
            Pid ! {self(), still_alive};
        {Pid, stop} ->
            %% db-ből törlés
            %% worker(ek) leállítása
            %% worker list legyen!

            %% dolgozatban nyitva hagyni: hogyan szól a többieknek, hogy megszunt?

            %% SQL-ben törli az összes kapcsolatát
            %% WHERE fromId = self() OR toId = self()
    end.

%% TODO: hálózat indítás, funkciók tesztelése
%% TODO: node létrehozásnál tábla insert, törlésnél delete
%% TODO: kapcsolatot eltárolni
%% TODO: node törlés: minden super
%% nem realtime: pollozás (receive after)

-include("neuron.hrl").

-export([init/2]).
% -export([loop/1]).

init(Node, #neuron_data{} = Data) ->
    F = parser:eval(Data#neuron_data.code),
    S = #neuron_state{func = F},
    Pid = spawn_link(Node, ?MODULE, loop, [S]),
    Pid ! {init, self()},
    Pid.

% loop(#neuron_state{} = State) ->
%     receive
%         {init, From} ->
%             ok;
%         {set_function, Code, From} ->
%             S = State#neuron_state{},
%             S#neuron_state{
%                 data = State#neuron_data{code = Code}, 
%                 func = parser:eval(Code)},
%             From ! {ok, set_function, self()},
%             loop(S);
%         {do, From} ->
%             F = State#neuron_state.func,
%             % Output = F()
%             From ! {ok, do, self()};
%         _ ->
%             loop(State)
%     end.
