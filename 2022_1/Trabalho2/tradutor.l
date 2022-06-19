%{
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;

int token;

void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void SU();
void casa( int );

void erro( string msg );
void print( string st );

enum { tk_cte_int = 256, tk_cte_double, tk_id, tk_print, tk_string };

%}

WS	[ \n\t]
D	[0-9]
L	[A-Za-z_]

INT	{D}+

NUM {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

STRING ("\""({L}|{D}|" "|"\'"|"\\"|"\\\""|"\"\""|"/"|"\*")*"\"")

ID	{L}({L}|{D})*

%%

{WS}		{ /* ignora espaços, tabs e '\n' */ }

{STRING} 	{ return tk_string; }
{INT}       { return tk_cte_int; }
{NUM}   	{ return tk_cte_double; }
"print" 	{ return tk_print; }

{ID}		  { return tk_id; }

.		{ return yytext[0]; }

%%

int next_token() {
  return yylex();
}

void A() {
// Guardamos o lexema pois a função 'casa' altera o seu valor.
  string temp = yytext; 
  switch( token ) {
    case tk_id : {
      casa( tk_id );
      print( temp );
      casa( '=' );
      E();
      print( "=" ); }
      break;
    case tk_print : {
      casa( tk_print );
      E();
      print( "print #" ); }
      break;
  }
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); print( "+" ); E_linha(); break;
    case '-' : casa( '-' ); T(); print( "-" ); E_linha(); break;
  }
}

void T() {
  SU();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); F(); print( "*" ); T_linha(); break;
    case '/' : casa( '/' ); F(); print( "/" ); T_linha(); break;
  }
}

void SU() {
  /* Sinais Unarios */
  switch ( token ) {
    case '+': casa( '+' ); T();
    case '-': print( "0" ); casa( '-' ); T(); print( "-" ); break;
    default: F();
  }
}

void F() {
  switch( token ) {
    case tk_id : {
      string temp = yytext;
      casa( tk_id ); print( temp + "@" ); } 
      break;
    case tk_cte_int: {
      string temp = yytext;
      casa( tk_cte_int ); print( temp ); }
      break;
    case tk_cte_double : {
      string temp = yytext;
      casa( tk_cte_double ); print( temp ); }
      break;
    case tk_string : {
        string temp = yytext;
        casa( tk_string ); print( temp ); }
        break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
    default:
      string temp = yytext;
      erro( "Operando esperado, encontrado " + temp );
  }
}


void casa( int esperado ) {
  if( token == esperado )
    token = next_token();
  else {
    printf( "Esperado %d, encontrado: %d\n", esperado, token );
    exit( 1 );
  }
}

void erro( string msg ) {
  cout << "=== Erro: " << msg << " ===" <<endl;
  exit( 1 );
}

void print( string st ) {
  cout << st << " ";
}

int main() {
  token = next_token();
  A();
  
  return 0;
}