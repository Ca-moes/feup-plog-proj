/*
  Include's of necessary files
*/
:- consult('display.pl').
:- consult('play.pl').
:- consult('inputs.pl').
:- consult('logic.pl').
:- consult('bot.pl').
:- consult('menus.pl').
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(random)).


% Start predicate
talpa :-
  play.
