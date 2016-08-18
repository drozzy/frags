%% Start the shell as:
%% erl -mnesia
%% to enable mnesia support.
-module(frags).
-export([create/0, activate/0, deactivate/0, add_frag/0, del_frag/0]).
-export([add_person/1, populate/1]).
-export([add_person_no_frag/1, populate_no_frag/1]).
-record(person, {name,
                 age = 0,
                 address = unknown,
                 salary = 0,
                 children = []}).


add_person(Name) ->
	T = fun() ->
		mnesia:write(#person{name=Name})
	end,
	mnesia:activity(transaction, T, [], mnesia_frag).

add_person_no_frag(Name) ->
	T = fun() ->
		mnesia:write(#person{name=Name})
	end,
	mnesia:activity(transaction, T).

populate_no_frag(N) ->
	[add_person_no_frag(X) || X <- lists:seq(1,N)].

%% Populate the db with N test data
populate(N) ->
	[add_person(integer_to_list(X)) || X <- lists:seq(1,N)].

create() ->
	application:stop(mnesia),
	mnesia:create_schema([node()|nodes()]),
	application:ensure_all_started(mnesia),
	create_tables(tables()),
	ok.

%% Adds new fragment to the table!
add_frag() ->
	mnesia:change_table_frag(person, {add_frag, [node()]}).

%% Removes an existing frag from the table
del_frag() ->
	mnesia:change_table_frag(person, del_frag).

%% Activate table frag for this table
activate() ->
	mnesia:change_table_frag(person, {activate,[]}).

%% Deactivate table fragmentation for this table
deactivate() ->
	mnesia:change_table_frag(person, deactivate).
%% Private
create_tables([]) -> ok;
create_tables([{Table, Options}|Rest]) ->
	mnesia:create_table(Table, Options),
	create_tables(Rest).

tables() ->
	[{person, 
		[{frag_properties, [{node_pool, [node()]},
		  {n_fragments, 2}, {n_disc_copies, 1}]},
		 {attributes, record_info(fields, person)}]}].
