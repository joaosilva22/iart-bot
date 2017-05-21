#!/usr/bin/swipl -f -q
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_ssl_plugin)).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(url)).
:- use_module(library(www_browser)).

:- set_prolog_flag(verbose, silent).
:- set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).

:- initialization main.

:- [hotels].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Server    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :-
  repeat,
  json_read(user_input, JSONIn),
  process_request(JSONIn, JSONOut),
  json_write(user_output, JSONOut),
  flush_output(user_output),
  fail.

process_request(JSONIn, JSONOut):-
  JSONIn = json(List),
  select(body=Message, List, _),
  select(senderID=Sender, List, _),
  answer(Sender, Message, Answer),
  JSONOut = json([senderID=Sender,body=Answer]).

% TODO: change the implementation of the answer predicate to 

answer(_Sender, Text, Answer):-
	format(atom(Answer), 'Hello').

%%%%%%%%%%%%%%%%%%%%%%%%%    Web Services Definition    %%%%%%%%%%%%%%%%%%%%%%%%%

ws(gkg).

ws(ox).

ws(bht).

% TODO: Add more web services here
% TODO: Replace <Key> with API keys and <ID> with app IDs

ws_info(gkg, [
  key="<Key>",
  host="kgsearch.googleapis.com",
  path="/v1/entities:search/",
  docUrl="https://developers.google.com/knowledge-graph/"
]).  

ws_info(ox, [
  key="<Key>",
  id="<ID>",
  host="od-api.oxforddictionaries.com",
  path="/api/v1/",
  docUrl="https://developer.oxforddictionaries.com/documentation#/"
]).

ws_info(bht, [
  key="<Key>",
  host="words.bighugelabs.com",
  path="/api/2/",
  docUrl="https://words.bighugelabs.com/api.php"
]).  

% TODO: Add information about the webservices here (API keys, host and path), 
% docURL will allow to open the documentation from the CLI.

%%%%%%%%%%%%%%%%%%%%%%%% Web Services Helper Predicates %%%%%%%%%%%%%%%%%%%%%%%%

get_ws_info(WS, Attributes):-
  nonvar(Attributes), !,
  ws_info(WS, Info),
  subset(Attributes, Info).

get_ws_info(WS, Attributes):-
    ws_info(WS, Attributes).

% Open browser to see documentation
check_docs(WS):-
  get_ws_info(WS, [docUrl=Url]),
  www_open_url(Url).

concat_delim(Delim, P2, P1, Result):-
  string_concat(P1, Delim, Temp),
  string_concat(Temp, P2, Result).

concat_delim(Delim, [First|Rest], Result):-
  foldl(concat_delim(Delim), Rest, First, Result).

concat_delim(_, [], "").

make_header(Key=Value, request_header(Key=Value)).

get_json(Url, Headers, Result):-
  maplist(make_header, Headers, Opt),
  setup_call_cleanup(
    http_open(Url, In, Opt),
    %copy_stream_data(In, user_output),
    json_read(In, Result),
    %write(Result),
    close(In)
  ).

default(DefaultVal, Val, X, Y):-
  var(X) -> Y = DefaultVal ; Y = Val.

default(DefaultVal, X, Y):-
  default(DefaultVal, X, X, Y).

join(Delim, List, Result):-
    is_list(List), !,
    concat_delim(Delim, List, Result).
    
join(_, String, String):-
    string(String).

request(Host, BasePath, PathParams, Search, Headers, Result):-
    default("", BasePath, BasePathVal),
    default("", PathParams, PathParamsVal),
    default([], [search(Search)], Search, SearchVal),
    default([], Headers, HeadersVal),
    join("/", BasePathVal, BasePathStr),
    join("/", PathParamsVal, PathParamsStr),
    string_concat(BasePathStr, PathParamsStr, Path),
    append([protocol(https), host(Host), path(Path)], SearchVal, List),
    parse_url(Url, List),
    get_json(Url, HeadersVal, Result).

%%%%%%%%%%%%%%%%%%%%%%%% Web Services Call Implementation %%%%%%%%%%%%%%%%%%%%%%%%

gkg(Query, Result):-
  gkg(Query, 1, Result).

gkg(Query, Num, Result) :-
  get_ws_info(gkg, [key=Key, host=Host, path=Path]),
  request(Host, Path, _, [query=Query, key=Key, limit=Num], _, Result).

oxford(Params, Result):-
  get_ws_info(ox, [key=Key, id=ID, host=Host, path=Path]),
  request(Host, Path, Params, _, [app_id=ID, app_key=Key], Result).

bht(Word, Result):-
  get_ws_info(bht, [key=Key, host=Host, path=Path]),
  request(Host, Path, [Key, Word, json], _, _, Result).

% TODO: To add support for more webservices, use get_ws_info to get the data   
% necessary to make API calls such as keys, ids, host name and path by passing 
% an association list Key=Value where Key is the parameter to extract and 
% Value is a variable that will contain the value associated with the atom in 
% the ws_info predicate. Then call request/6 with the hostname, the base path to 
% the API, the path parameters to the API (will be separated by "/" in the URL), 
% then the search parameters and finally the headers to add to the request  
% specific to that web service. The result will be a Prolog term representing 
% the JSON object returned by the API.

