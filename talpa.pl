/*
  Include's of necessary files
*/
:- consult('display.pl').
:- consult('play.pl').
:- consult('inputs.pl').
:-use_module(library(lists)).

% Start predicate
talpa :-
  play.
