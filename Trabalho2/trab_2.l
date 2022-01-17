%{
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <map>
  
using namespace std;

int token;

void P();
void A();
void R();
void L();
void V();
void VS();
void T();
void casa( int );

enum { tk_int = 256, tk_char, tk_double, tk_id, tk_cte_int, tk_str, tk_float };

map<int,string> nome_tokens = {
  { tk_int, "int" },
  { tk_char, "char" },
  { tk_double, "double" },
  { tk_id, "nome de identificador" },
  { tk_cte_int, "constante inteira" },
  { tk_str, "string" },
  { tk_float, "float" }
};

%}

D       [0-9]
L       [A-Za-z_]

WS	    [ \n\t]
STRING  (("\"")(({L}|{D}|{WS}|("\\")|("\'")|("\\\"")|("\"\""))*)("\""))

NUM	    {D}+
FLOAT   {NUM}("."{NUM})?([Ee]("+"|"-")?{NUM})?
ID	    ({L})({L}|{D})*

%%

{WS}  		{ }
{STRING}    { return tk_str; }
{NUM} 		{ return tk_cte_int; }
{FLOAT}     { return tk_float; }
"char"		{ return tk_char; }
"int"		{ return tk_int; }
"double"	{ return tk_double; }

{ID}		{ return tk_id; }

.		{ return yytext[0]; }

%%

int next_token() {
  return yylex();
}

string nome_token( int token ) {
  if( nome_tokens.find( token ) != nome_tokens.end() )
    return nome_tokens[token];
  else {
    string r;
    
    r = token;
    return r;
  }
}

void P() {
  if( token == '*' ) {
    casa( '*' );
    P();
  }
}

void A() {
  if( token == '[' ) {
    casa( '[' );
    casa( tk_cte_int );
    casa( ']' );
    A();
  }
}

void R() {
  if( token == ',' ) {
    casa( ',' );
    P();
    casa( tk_id );
    A();
    R();
  }
}

void L() {
  P();
  casa( tk_id );
  A();
  R();
}

void T() {
  switch( token ) {
    case tk_int : casa( tk_int ); break;
    case tk_char : casa( tk_char ); break;
    case tk_double : casa( tk_double ); break;
    
    default:
      cout << "Tipo esperado "  
	   << " , encontrado: " << nome_token( token ) << endl;
    exit( 1 );
  }
}

void V() {
  T();  
  L(); 
  casa( ';' );
}


void casa( int esperado ) {
  if( token == esperado )
    token = next_token();
  else {
      cout << "Esperado " << nome_token( esperado ) 
	   << " , encontrado: " << nome_token( token ) << endl;
    exit( 1 );
  }
}

void VS() {
  V();
  switch( token ) { // verificando se o próximo símbolo da entrada
		    // é o início de uma declaração de variável.
    case tk_int:
    case tk_char:
    case tk_double:
      VS();
      break;
  }
}

int main() {
  token = next_token();
  VS();
  
  if( token == 0 )
    cout << "Sintaxe ok!" << endl;
  else
    cout << "Caracteres encontrados após o final do programa" << endl;
  
  return 0;
}

/*
A -> id { Print( id ); } = E { Print( "="); }
void A() {
    casa(ID); Print( lexema ); casa ("="); E(); Print( "=");
}
E -> E + T { Print( "+"); }
    | E - T { Print( "-"); }
    | T
T -> T * F { Print( "*"); }
    | T / F { Print( "/"); }
    | F
F -> id { Print(id + "@"); }
    | num { Print( num ); }
    | ( E )
X -> P ^ X
    | P
P -> P |
    | F
*/