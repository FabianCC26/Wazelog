:-consult(locations).
:-consult(grammar_analysis).


% Member
miembro(X, [X|_]):- !.
miembro(X, [_| R]):- miembro(X,R).

% Reverse
invertir(X,Y):- invertir(X,Y,[]).
invertir([],Z,Z).
invertir([Head|Tail],Z, Collector):- invertir(Tail,Z,[Head|Collector]).


% Database search

% Check if it is a sentence according to what is structured
es_oracion(S):-
	oracion(S, []), !.

% Check if it is a denial
es_negativo(N):-
	negativo(N,[]), !.

% Check if it is an affirmation.
es_afirmativo(Y):-
	afirmativo(Y,[]), !.

% Revisa si es una ciudad
es_ciudad(C, Ciudad):-
	miembro(Ciudad, C),
	ciudad(C, []), !.

es_ciudad(Ciudad):-
	miembro(Ciudad, C),
	ciudad(C, []), !.

% Check if it is a city
es_local(L, Local):-
	miembro(Local, L),
	local(L, []), !.

es_local(Local):-
	miembro(Local, L),
	local(L, []), !.

% Check if it is an establishment
es_establecimiento(E, Establecimiento):-
	miembro(Establecimiento, E),
	establecimiento(E, []), !.

es_establecimiento(Establecimiento):-
	miembro(Establecimiento, E),
	establecimiento(E, []), !.


% Look for an affirmative answer in the entire sentence
respuesta_afirmativa(X):-
	parseToList(X,Y),
	buscar_respuesta_afirmativa(Y).

buscar_respuesta_afirmativa([X|_]):-
	nth0(0, R, X, []),
	es_afirmativo(R), !.
buscar_respuesta_afirmativa([_|Y]):-
	buscar_respuesta_afirmativa(Y).

% Look for a negative answer in the entire sentence
respuesta_negativa(X):-
	parseToList(X,Y),
	buscar_respuesta_negativa(Y).

buscar_respuesta_negativa([X|_]):-
	nth0(0, R, X, []),
	es_negativo(R), !.
buscar_respuesta_negativa([_|Y]):-
	buscar_respuesta_negativa(Y).


% Look if within the sentence there is a place, establishment or city that exists
search_lugar(X, Lugar):-
	parseToList(X,Y),
	buscar_lugar(Y, Lugar).

% Search for a location, establishment or city in the entire sentence.
buscar_lugar([X|_], Lugar):-
	nth0(0, L, X, []),
	( es_ciudad(L, Lugar); es_local(L, Lugar); es_establecimiento(L, Lugar)), !.

buscar_lugar([_|Y], Lugar):-
	buscar_lugar(Y, Lugar).


% Search within the sentence for a city that exists
search_ciudad(X, Ciudad):-
	parseToList(X,Y),
	buscar_ciudad(Y, Ciudad).

% Search city in the entire sentence
buscar_ciudad([X|_], Ciudad):-
	nth0(0, L, X, []),
	es_ciudad(L, Ciudad), !.
buscar_ciudad([_|Y], Ciudad):-
	buscar_ciudad(Y, Ciudad).


% Search within the sentence for a city that exists
search_local(X, Local):-
	parseToList(X,Y),
	buscar_local(Y, Local).

% Searh establisment in the entire sentence
buscar_local([X|_], Local):-
	nth0(0, L, X, []),
	es_local(L, Local), !.
buscar_local([_|Y], Local):-
	buscar_local(Y, Local).


% Search within the sentence for a city that exists
search_establecimiento(X, Establecimiento):-
	parseToList(X,Y),
	buscar_establecimiento(Y, Establecimiento).

% Find establishment in the entire sentence
buscar_establecimiento([X|_], Establecimiento):-
	nth0(0, L, X, []),
	es_establecimiento(L, Establecimiento), !.
buscar_establecimiento([_|Y], Establecimiento):-
	buscar_establecimiento(Y, Establecimiento).



%%%% Parser %%%%

% Converts each word in a string to an element in the output list

atomo_a_string(L1, L):-  atomo_a_string(L1,[],L).
atomo_a_string([], L, L).
atomo_a_string([X|L1], L2, L3):-
	downcase_atom(X, Y),
	text_to_string(Y, String),
	atomo_a_string(L1, [String|L2], L3).

% Elimina los signos de puntuacion
eliminar_puntuacion(X, S5):-
	delete(X, ",", S1),
	delete(S1, ".", S2),
	delete(S2, "!", S3),
	delete(S3, ";", S4),
	delete(S4, "?", S5).

% Receives the input and returns it parsed to a list of strings
parseToList(X,W):-
    atomo_a_string(X, Y),
	eliminar_puntuacion(Y, Z),
    invertir(Z,W).


%%%% User input validation %%%%

% Check if the user's input is equivalent to a sentence
validacion_entrada(Input):-
	validacion_entrada_aux(Input),!.

validacion_entrada(Input):-
	error_entrada,
	validacion_entrada(Input).


validacion_entrada_aux(Input):-
	readln(Ans),
	parseToList(Ans,Input),
    es_oracion(Input).

error_entrada:-
    writeln('\n- WazeLog: Lo siento, no entendi').


%%%% Yes or No Validation %%%%

% Check if the user's input is equivalent to a sentence
validacion_si_o_no(Input):-
	validacion_si_o_no_aux(Input),!.

validacion_si_o_no(Input):-
	error_si_o_no,
	validacion_si_o_no(Input).

validacion_si_o_no_aux(Input):-
	readln(Ans),
	parseToList(Ans,Input),
    ( es_afirmativo(Input); es_negativo(Input) ).

error_si_o_no:-
    writeln('\n- WazeLog: Si o no?').

%%%% validate input location %%%%

% Checks if the user's entry exists in the database.
validacion_lugar(Input):-
	validacion_lugar_aux(Input),!.

validacion_lugar(Input):-
	error_lugar,
	validacion_lugar(Input).

validacion_lugar_aux(Lugar):-
	validacion_entrada(Ans),
	search_lugar(Ans,Lugar).

error_lugar:-
    writeln('\n WazeLog: Ese lugar no lo conozco. \nIngrese otro, por favor.').


%%%% Validate input city %%%%

% Checks if the user's entry exists in the database
validacion_ciudad(Input):-
	validacion_ciudad_aux(Input),!.

validacion_ciudad(Input):-
	error_ciudad,
	validacion_ciudad(Input).

validacion_ciudad_aux(Ciudad):-
	validacion_entrada(Ans),
	search_ciudad(Ans,Ciudad).

error_ciudad:-
    writeln('\n WazeLog: Esa ciudad no la conozco.\nIngrese otra, por favor.').



%%%% Validate input establishment %%%%

% Checks if the user's entry exists in the database
validacion_local(Input):-
	validacion_local_aux(Input),!.

validacion_local(Input):-
	error_local,
	validacion_local(Input).


validacion_local_aux(Local):-
	validacion_entrada(Ans),
	search_local(Ans,Local).

error_local:-
    writeln('\n WazeLog: Disculpe, aun no conozco ese local.\n¡Por favor ingrese uno valido!').














