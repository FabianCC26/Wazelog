:-consult(locations).

% Negative inputs
negativo(["no"|S], S).
negativo(["n"|S], S).
negativo(["ninguno"|S], S).

% Positive inputs
afirmativo(["si"|S], S).
afirmativo(["s"|S], S).
afirmativo(["afirmativo"|S], S).

% Adverbs
adverbio(["no"|S], S).
adverbio(["n"|S], S).
adverbio(["ninguno"|S], S).
adverbio(["si"|S], S).
adverbio(["s"|S], S).
adverbio(["afirmativo"|S], S).

% Pronouns
pronombre(personal, singular,["yo"|S],S).
pronombre(personal, plural,["nosotras"|S],S).
pronombre(personal, plural,["nosotros"|S],S).
pronombre(reflexivo, singular,["me"|S],S).
pronombre(reflexivo, plural,["nos"|S],S).
pronombre(posesivo, singular,["mi"|S],S).
pronombre(posesivo, singular,["nuestro"|S],S).
pronombre(impersonal, _,["se"|S],S).

% Articles
articulo(masculino, singular, ["el"|S], S).
articulo(masculino, singular, ["al"|S], S).
articulo(masculino, plural, ["los"|S], S).
articulo(femenino, singular, ["la"|S], S).
articulo(femenino, plural, ["las"|S], S).
articulo(masculino, singular, ["un"|S], S).
articulo(masculino, plural, ["unos"|S], S).
articulo(femenino, singular, ["una"|S], S).
articulo(femenino, plural, ["unas"|S], S).

% Nouns
sustantivo(masculino, singular,["destino"|S], S).
sustantivo(masculino, singular,["lugar"|S], S).

% Adjectives
adjetivo(masculino, singular,["destino"|S], S).
adjetivo(masculino, singular,["instermedio"|S], S).

% Verbs
verbo(copulativo, _, ["es"|S], S).
verbo(copulativo, singular, ["estoy"|S], S).

verbo(infinitivo, _, ["ir"|S], S).
verbo(infinitivo, _, ["llegar"|S], S).
verbo(infinitivo, _, ["pasar"|S], S).

verbo(intransitivo, singular, ["viajo"|S], S).
verbo(intransitivo, singular, ["voy"|S], S).
verbo(intransitivo, plural, ["vamos"|S], S).

verbo(reflexivo, singular, ["dirijo"|S], S).
verbo(reflexivo, plural, ["dirigirnos"|S], S).
verbo(reflexivo, singular, ["encuentro"|S], S).
verbo(reflexivo, singular, ["encuentra"|S], S).
verbo(reflexivo, plural, ["encontramos"|S], S).
verbo(reflexivo, singular, ["ubico"|S], S).
verbo(reflexivo, singular, ["ubica"|S], S).


verbo(transitivo, singular, ["llama"|S], S).
verbo(transitivo, singular, ["quiero"|S], S).
verbo(transitivo, plural, ["queremos"|S], S).
verbo(transitivo, singular, ["necesito"|S], S).
verbo(transitivo, plural, ["necesitamos"|S], S).

% Prepositions
preposicion(finalidad, ["a"|S], S).
preposicion(finalidad, ["para"|S], S).
preposicion(lugar, ["para"|S], S).
preposicion(lugar, ["a"|S], S).
preposicion(lugar, ["en"|S], S).
preposicion(lugar, ["cerca"|S], S).
preposicion(lugar, ["alrededor"|S], S).
preposicion(lugar, ["junto"|S], S).
preposicion(lugar, ["por"|S], S).
preposicion(conexion, ["a"|S], S).
preposicion(conexion, ["de"|S], S).


%%%% Syntagms %%%%

%%%% Nominal syntagm %%%%
sintagma_nominal(N, S0, S):-
    pronombre(_, N, S0,S).

sintagma_nominal(N, S0, S):-
    pronombre(personal, N, S0,S1),
    pronombre(reflexivo, N, S1,S).

sintagma_nominal(N, S0, S):-
    pronombre(posesivo, N, S0,S1),
    sustantivo(_, N, S1,S).


sintagma_nominal(N, S0, S):-
    pronombre(posesivo, N, S0,S1),
    sustantivo(G, N, S1,S2),
    adjetivo(G, N, S2,S), S1\=S2.

% City
sintagma_nominal(_, S0, S):-
    ciudad(S0,S).

sintagma_nominal(N, S0, S):-
    articulo(_,N,S0,S1),
    ciudad(S1,S).

% Place
sintagma_nominal(_, S0, S):-
    local(S0,S).

sintagma_nominal(N, S0, S):-
    articulo(_,N,S0,S1),
    local(S1,S).

% Establishment
sintagma_nominal(_, S0, S):-
    establecimiento(S0,S).

sintagma_nominal(_, S0, S):-
    articulo(_,_,S0,S1),
    establecimiento(S1,S).

sintagma_nominal(_, S0, S):-
    articulo(_,_,S0,S1),
    establecimiento(S1,S2),
    local(S2,S).


%%%% Verbal syntagm %%%%
sintagma_verbal(N,S0,S):-
    verbo(_, N, S0, S1),
    sintagma_preposicional(N,S1,S).

sintagma_verbal(N,S0,S):-
    verbo(transitivo, N, S0, S1),
    verbo(infinitivo, _, S1, S2),
    sintagma_preposicional(N,S2,S).


sintagma_verbal(N,S0,S):-
    verbo(transitivo, N, S0, S1),
    verbo(infinitivo, _, S1, S2),
    sintagma_nominal(N,S2,S).

sintagma_verbal(N,S0,S):-
    verbo(reflexivo, N, S0, S1),
    preposicion(finalidad, S1, S2),
    verbo(infinitivo, N, S2, S3),
    sintagma_preposicional(N,S3,S).

%%%% Prepositional syntagm %%%%

sintagma_preposicional(_, S0, S):-
	ciudad(S0, S).

% Sintagma preposicional. (Ej: supermercado)
sintagma_preposicional(_, S0, S):-
	local(S0, S).

sintagma_preposicional(_, S0, S):-
	establecimiento(S0, S).

sintagma_preposicional(N, S0, S):-
    preposicion(_,S0,S1),
    sintagma_nominal(N,S1,S).

sintagma_preposicional(N, S0, S):-
    preposicion(lugar,S0,S1),
    preposicion(conexion,S1,S2),
    sintagma_nominal(N,S2,S).


%%%% Sentences %%%%

oracion(S0,S):-
    adverbio(S0,S).

oracion(S0,S):-
    sintagma_nominal(_,S0,S).

oracion(S0,S):-
    sintagma_preposicional(_,S0,S).

oracion(S0,S):-
    sintagma_nominal(_,S0,S1),
    sintagma_preposicional(_,S1,S).


oracion(S0,S):-
    sintagma_verbal(_,S0,S).

oracion(S0,S):-
    adverbio(S0,S1),
    sintagma_nominal(_,S1,S).

oracion(S0,S):-
    adverbio(S0,S1),
    sintagma_preposicional(_,S1,S).

oracion(S0,S):-
    adverbio(S0,S1),
    sintagma_verbal(_,S1,S).

oracion(S0,S):-
    sintagma_nominal(N,S0,S1),
    sintagma_verbal(N,S1,S).

oracion(S0,S):-
    sintagma_nominal(N,S0,S1),
    sintagma_preposicional(N,S1,S).


oracion(S0,S):-
    sintagma_nominal(_,S0,S1),
    sintagma_verbal(_,S1,S2),
    sintagma_preposicional(_,S2,S).
