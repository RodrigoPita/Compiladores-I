%{
#include <stdlib.h>
#include <stdio.h>
  
int token;

void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void casa( int );

enum { ID = 256, NUM, PRINT, STRING };
%}

WS	        [ \t\n]

D           [0-9]
L           [a-zA-Z_á]

ID          {L}({L}|{D})*

INT         {D}+

NUM	{INT}("."{INT})?([Ee]("+"|"-")?{INT})?

STRING      ("\""({L}|{D}|" "|"\'"|"\\"|"\\\""|"\"\""|"/"|"\*")*"\"")

%%

{WS}		{ /* ignora espaços, tabs e '\n' */ }

{STRING} 	{ return STRING; }
{NUM}   	{ return NUM; }
"print" 	{ return PRINT; }

{ID}		{ return ID; }

.		{ return yytext[0]; }

%%

int next_token() {
  return yylex();
}

void A() {
// Guardamos o lexema pois a função 'casa' altera o seu valor.
  string temp = lexema; 
  casa( ID );
  print( temp );
  casa( '=' );
  E();
  print( "=" );
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); print( "+"); E_linha(); break;
    case '-' : casa( '-' ); T(); print( "-"); E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' : casa( '*' ); F(); print( "*"); T_linha(); break;
    case '/' : casa( '/' ); F(); print( "/"); T_linha(); break;
  }
}

void F() {
  switch( token ) {
    case ID : {
      string temp = lexema;
      casa( ID ); print( temp + "@" ); } 
      break;
    case NUM : {
      string temp = lexema;
      casa( NUM ); print( temp ); }
      break;
    case STRING : {
        string temp = lexema;
        casa( STRING ); print( temp ); }
        break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
    default:
      erro( "Operando esperado, encontrado " + lexema );
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

int main() {
  token = next_token();
  A();
  
  return 0;
}