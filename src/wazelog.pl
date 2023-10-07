:-consult(locations).
:-consult(input_processing).
:-consult(grammar_analysis).
:-consult(pathfinder).



start():-
    writeln('\nWazeLog: Bienvenido a WazeLog la mejor logica de llegar a su destino!'),
    writeln('         Por favor indiqueme donde se encuentra.'),
    ubicacion(Inicio),

    writeln('\nWazeLog: Muy bien, ¿Cual es su destino?'),
    ubicacion(Destino),

    writeln('\nWazeLog: Excelente, ¿Tiene algun destino intermedio? (si / no)'),
    intermedio([], List),

    nl,

    %Realizar una sola lista.
    append([Inicio],List,L1),
    append(L1,[Destino],L2),

    getPath(L2,P,W,T),
    writeln("----------------------------------------------------------------------------------------------------------------------"),
    writeln(P - W - T),
    writeln("----------------------------------------------------------------------------------------------------------------------"),
    start.


%Show the route, shortest path and estimated time
getPath(List_Places,Path,Weight,Time):-
    findminpath_t(List_Places,W,T,P),

    parse_ruta(P, '', Path_string),
    atom_concat('  Su ruta seria: ',Path_string, Path),

    atom_concat('  Distancia total del recorrido: ',W, Z),
    atom_concat(Z,' km.', Weight),

    atom_concat('  Tiempo promedio estimado: ', T, X),
    atom_concat(X, ' min.', Time).


%Rute parser
parse_ruta(List, S, Output):-
    parse_ruta_aux(List,S, Output).

parse_ruta_aux([X], S, Output):-
    atom_concat(S,X,Z),
    atom_concat(Z,'.',Output).

parse_ruta_aux([H|T], S, Output):-
    atom_concat(S,H,X),
    atom_concat(X,', ',Y),
    parse_ruta_aux(T,Y, Output).


%%%% Place validation %%%%

% Checks if the input place exist
ubicacion(Lugar):-
    validacion_entrada(Input),
	encontrar_lugar(Input, Lugar).

% Find city
encontrar_lugar(Lugar,Nombre):-
	search_ciudad(Lugar,Nombre),
	es_ciudad(Nombre),
	!.

% Find place.
encontrar_lugar(Lugar,Ciudad):-
	search_local(Lugar,Nombre),
	es_local(Nombre),
	print_info_local(Nombre,Ciudad),
	!.

% Find establisment
encontrar_lugar(Lugar,Local):-
	search_establecimiento(Lugar,Nombre),
	es_establecimiento(Nombre),
	print_info_establecimiento(Nombre, Local),
	!.

encontrar_lugar(_, Lugar):-
    error_lugar,
    encontrar_lugar_aux(_, Lugar).

encontrar_lugar_aux(_, Lugar):-
    validacion_lugar(Input),
    miembro(Input,Parsed),
	encontrar_lugar(Parsed, Lugar).

%%%% Prints %%%%
print_info_local(Local,Ciudad):-
    atom_concat('\nWazeLog: Donde se encuentra ',Local,A),
    atom_concat(A,'?',B),
    writeln(B),
    validacion_ciudad(Ciudad),
    !.

print_info_establecimiento(Establecimiento, Ciudad):-
    atom_concat('\nCual ', Establecimiento, A),
    atom_concat(A, ' es?',B),
    writeln(B),
    validacion_local(Local),

    atom_concat(Establecimiento, " ",X),
    atom_concat(X, Local,Y),
    print_info_local(Y,Ciudad),
    !.



%%%% Consult intermediate place %%%%

% Facts if a list is empty
list_empty([], true).
list_empty([_|_], false).

% Concatenates two lists
concatenate(List1, List2, Result):-
    append(List1, List2, Result).


respuesta(Input):-respuesta_negativa(Input),fail.

respuesta(Input):- respuesta_afirmativa(Input),!.

% Funcion if then else, of answer
intermedio(L1, Places):-
    validacion_si_o_no(Y),
    parseToList(Y,Z),
    ( respuesta(Z)
    ->
        (writeln('\nWazeLog: Cual?'),
        ubicacion(City),
        append(L1, [City], X),

        writeln('\nWazeLog: Alguna otra parada intermedia? (s / n)'),
        intermedio(X, Places))
    ;
        concatenate(L1,[], Places)
    ).
















