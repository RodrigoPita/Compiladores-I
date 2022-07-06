%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <map>

using namespace std;

struct Atributos {
  vector<string> c;
};

#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

vector<string> concatena( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, string b );
vector<string> resolve_enderecos( vector<string> entrada );
void imprime_codigo( vector<string> codigo );

Atributos gera_operador( Atributos s1, 
                         Atributos s3, 
                         Atributos s2 );

%}

%token NUM STR ID LET MAIS_IG

%right MAIS_IG
%right '='
%nonassoc '<' '>'
%left '+' '-'
%left '*' '/' '%'

// Start indica o símbolo inicial da gramática
// %start S

%%

RAIZ : S    { imprime_codigo( resolve_enderecos( $1.c ) ); }
     ;

S : CMD S   { $$.c = $1.c + $2.c; }
  |         { $$.c.clear(); }
  ;

CMD : CMD_LET
    | RVALUE ';'    { $$.c = $1.c + "^"; }
    ;

CMD_LET : LET IDs ';'   { $$ = $2; }
        ;

IDs : UM_ID ',' IDs     { $$.c = $1.c + $3.c; }
    | UM_ID
    ;

UM_ID : ID      { $$.c = $1.c + "&"; }
      | ID '=' RVALUE
        { $$.c = $1.c + "&" + $1.c + $3.c + "=" + "^"; }

LVALUE : ID
       ;

ATRIB : LVALUE '=' RVALUE   { $$.c = $1.c + $3.c + "="; }
      | LVALUE MAIS_IG RVALUE   { $$.c = $1.c + $1.c + "@" + $3.c + "+" + "="; }
      ;

RVALUE : E
       | ATRIB
       | LVALUE
       ;

E : E '+' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '-' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '*' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '/' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '<' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '>' E     { $$ = gera_operador( $1, $3, $2 ); }
  | F
  ;

F : NUM
  | STR
  | '(' E ')'   { $$.c = $2.c; }
  | '{' '}'     { $$.c.clear(); $$.c.push_back( "{}" ); }
  | '[' ']'     { $$.c.clear(); $$.c.push_back( "[]" ); }
         
%%

#include "lex.yy.c"

void imprime_codigo( vector<string> codigo ) {
    for( string instrucao : codigo )
        cout << instrucao << " ";
    cout << "." << endl;
}

vector<string> resolve_enderecos( vector<string> entrada ) {
  map<string,int> label;
  vector<string> saida;
  for( int i = 0; i < entrada.size(); i++ ) 
    if( entrada[i][0] == ':' ) 
        label[entrada[i].substr(1)] = saida.size();
    else
      saida.push_back( entrada[i] );
  
  for( int i = 0; i < saida.size(); i++ ) 
    if( label.count( saida[i] ) > 0 )
        saida[i] = to_string(label[saida[i]]);
    
  return saida;
}

Atributos gera_operador( Atributos s1, Atributos s3, Atributos s2 ) {
        Atributos ss;
        ss.c = s1.c + s3.c + s2.c;
    return ss;
}

void yyerror( const char* st ) {
   puts( st ); 
   printf( "Proximo a: %s\n", yytext );
   exit( 1 );
}

vector<string> concatena( vector<string> a, vector<string> b ) {
  a.insert( a.end(), b.begin(), b.end() );
  return a;
}

vector<string> operator+( vector<string> a, vector<string> b ) {
  return concatena( a, b );
}

vector<string> operator+( vector<string> a, string b ) {
  a.push_back( b );
  return a;
}

int main( int argc, char* argv[] ) {
  yyparse();
  
  return 0;
}