%{
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <map>
#include <stdbool.h>

using namespace std;

struct Atributos {
  vector<string> c;
};

#define YYSTYPE Atributos

int yylex();
int yyparse();
void yyerror(const char *);

map<string, bool> vars;
vector<string> inicio_vazio;
string gera_label( string prefixo );
vector<string> concatena( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, vector<string> b );
vector<string> operator+( vector<string> a, string b );
vector<string> resolve_enderecos( vector<string> entrada );
void imprime_codigo( vector<string> codigo );
void testa_var( Atributos var_teste );
void testa_var_2( Atributos var_teste );

Atributos gera_operador( Atributos s1, 
                         Atributos s3, 
                         Atributos s2 );

%}

%token NUM STR ID LET MAIS_IG IF ELSE FOR WHILE MAIG MEIG IG INCR

%right MAIS_IG INCR

%right '='
%nonassoc '<' '>'
%left IG MAIG MEIG
%left '+' '-'
%left '*' '/' '%'
%left '['
%left '.'

// Start indica o símbolo inicial da gramática
// %start S

%%

RAIZ : S    { imprime_codigo( resolve_enderecos( $1.c ) ); }
     ;

S : CMD S   { $$.c = $1.c + $2.c; }
  |         { $$.c.clear(); }
  ;

CMD : CMD_LET
    | CMD_IF_ELSE
    | CMD_IF
    | CMD_WHILE
    | RVALUE ';'    { $$.c = $1.c + "^"; }
    ;

CMD_WHILE : WHILE '(' COND ')' BLOCO { string while_inicio = gera_label( "WHILE" ), while_fim = gera_label( "ELIHW" );
                                      $$.c = inicio_vazio + ( ":" + while_inicio ) + $3.c + "!" + while_fim + "?" + $5.c + while_inicio + "#" + ( ":" + while_fim ); }

CMD_IF : IF '(' COND ')' BLOCO { string if_incio = gera_label( "IF" ), if_fim = gera_label( "FI" ); 
                                $$.c = $3.c + if_incio + "?" + if_fim + "#" + ( ":" + if_incio )  + $5.c + ( ":" + if_fim ); }
       ;

CMD_IF_ELSE : IF '(' COND ')' BLOCO ELSE BLOCO { string if_incio = gera_label( "ELIF"), if_fim = gera_label( "FILE" ); 
                                                $$.c = $3.c + "!" + if_incio + "?" + $5.c + if_fim + "#" + ( ":" + if_incio ) + $7.c + ( ":" + if_fim ); }
            ;
            
CMD_LET : LET IDs ';'   { $$ = $2; }
        ;

IDs : UM_ID ',' IDs     { $$.c = $1.c + $3.c; }
    | UM_ID 
    ;

UM_ID : ID      { $$.c = $1.c + "&"; testa_var( $1 ); vars[$1.c[0]] = true; }
      | ID '=' RVALUE        { $$.c = $1.c + "&" + $1.c + $3.c + "=" + "^"; testa_var( $1 ); vars[$1.c[0]] = true; }
      ;

COND : E '>' E    { $$ = gera_operador( $1, $3, $2 ); }
     | E '<' E    { $$ = gera_operador( $1, $3, $2 ); }
     | E MAIG E   { $$ = gera_operador( $1, $3, $2 ); }
     | E MEIG E   { $$ = gera_operador( $1, $3, $2 ); }
     | E IG E     { $$ = gera_operador( $1, $3, $2 ); }
     | E
     ;

BLOCO : '{' S '}'   { $$.c = $2.c; }
      | CMD           { $$.c = $1.c; }
      | '{' '}'     { $$.c.clear(); $$.c.push_back( "" ); }
      ;

LVALUE : ID
       ;

LVALUEPROP : LVALUE PROP    { $$.c = $1.c + "@" + $2.c; }
           ;

PROP : '[' RVALUE ']' PROP  { $$.c = $2.c + "[@]" + $4.c; }
     | '.' ID PROP          { $$.c = $2.c + "[@]" + $3.c; }
     | '[' RVALUE ']'       { $$.c = $2.c; }
     | '.' ID               { $$.c = $2.c; }
     ;

ATRIB : LVALUE '=' RVALUE   { $$.c = $1.c + $3.c + "="; testa_var_2( $1 ); }
      | LVALUE MAIS_IG RVALUE   { $$.c = $1.c + $1.c + "@" + $3.c + "+" + "=";  }
      | LVALUEPROP '=' RVALUE { $$.c = $1.c + $3.c + "[=]"; }
      | LVALUEPROP MAIS_IG RVALUE   { $$.c = $1.c + $1.c + "[@]" + $3.c + "+" + "[=]";  }
      ;

RVALUE : E    
       | ATRIB 
       ;

E : E '+' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '-' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '*' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '/' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '<' E     { $$ = gera_operador( $1, $3, $2 ); }
  | E '>' E     { $$ = gera_operador( $1, $3, $2 ); }
  | '-' E       { $$.c = inicio_vazio + "0" + $2.c + "-"; }
  | F
  ;

F : NUM 
  | STR
  | LVALUE     { $$.c = $1.c + "@"; }
  | LVALUEPROP { $$.c = $1.c + "[@]"; }
  | LVALUE INCR   { $$.c = $1.c + "@" + $1.c + $1.c + "@" + "1" + "+" + "=" + "^"; }
  | '(' RVALUE ')'   { $$.c = $2.c; }
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

void testa_var( Atributos var_teste ) {
  string v = var_teste.c[0];
  if( vars[v] ) {
    cout << "Erro: a variável '" << v << "' já foi declarada na linha 1" << "." << endl;
    exit(1);    
  }
}

void testa_var_2( Atributos var_teste ) {
  string v = var_teste.c[0];
  if( !( vars[v] ) ) {
    cout << "Erro: a variável '" << v << "' não foi declarada." << endl;
    exit(1);
  }
}

string gera_label( string prefixo ) {
  static int n = 0;
  return prefixo + "_" + to_string( ++n ) + ":";
}

int main( int argc, char* argv[] ) {
  yyparse();
  
  return 0;
}