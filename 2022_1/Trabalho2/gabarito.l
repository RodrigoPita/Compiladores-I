%{ 
#include <stdlib.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

enum TOKEN { NUM = 256, STR, ID, PRINT };

map<int,string> nome_tokens = {
  { PRINT, "print" },
  { STR, "string" },
  { ID, "nome de identificador" },
  { NUM, "número" }
};

int linha = 1;
int coluna = 1;
string lexema;

int retorna( int );
void erro( string msg );

int token;

void P();
void A();
void E();
void E_linha();
void T();
void T_linha();
void F();
void Args();

%}

DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR 	\"([^\"\n]|(\\\")|\"\")+\"

%%

"\t"       { coluna += 4; }
" "        { coluna++; }
"\n"	   { linha++; coluna = 1; }

{DOUBLE}   { return retorna( NUM ); }
{STR}	   { return retorna( STR ); }

"print"    { return retorna( PRINT ); }

{ID}       { return retorna( ID ); }

.          { return retorna( *yytext ); }

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

int retorna( int tk ) {  
  lexema = yytext; 
  coluna += strlen( yytext ); 

  return tk;
}

void casa( int esperado ) {
  if( token == esperado )
    token = next_token();
  else {
      cout << "Esperado '" << nome_token( esperado ) 
	   << "', encontrado '" << nome_token( token ) << "'" << endl;
    exit( 1 );
  }
}

void print( string st ) {
  cout << st << " ";
}

void P() {
  switch( token ) {
    case ID: A(); casa( ';' ); P(); break;
    case PRINT: casa( PRINT ); E(); print( "print #" ); casa( ';' ); P(); break;
  }  
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
	casa( ID ); 
	
	if( token == '(' ) {
	  casa( '(' );
	  Args(); 
	  casa( ')' );
	  print( temp + " #" ); 	  
	}
	else
	  print( temp + " @" ); 
      } 
      break;
    case NUM : {
	string temp = lexema;
	casa( NUM ); print( temp ); 
      }
      break;
    case STR : {
	string temp = lexema;
	casa( STR ); print( temp ); 
      }
      break;
    case '(': 
      casa( '(' ); E(); casa( ')' ); break;
    default:
      cout << "Operando esperado, encontrado " << lexema << endl;
      exit( 1 );
  }
}

void Args() {
  if( token != ')' ) {
    E();
    while( token == ',' ) {
      casa( ',' );
      E();
    }
  }
}

int main() {
  token = next_token();
  P();
  
  cout << endl;
  
  if( token != 0 )
    cout << "Caracteres encontrados após o final do programa" << endl;
  
  return 0;
}