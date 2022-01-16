%{
#include <stdlib.h>
#include <stdio.h>
#include <string>
  
int token;

void P();
void A();
void R();
void L();
void V();
void T();
void casa( int );

enum { tk_int = 256, tk_char, tk_double, tk_id, tk_cte_int, tk_str, tk_float };
%}

D       [0-9]
L       [A-Za-z_]
S       [_$/*]

WS	    [ \n\t]
STRING  (("\"")(({L}|{D}|{WS}|{S}|("\\")|("\'")|("\\\"")|("\"\""))*)("\""))

NUM	    {D}+
FLOAT   {NUM}("."{NUM})?([Ee]("+"|"-")?{NUM})?
ID	    ({L}|{S})({L}|{D}|{S})*

%%

{WS}  		{ }
{NUM} 		{ return tk_cte_int; }
"char"		{ return tk_char; }
"int"		{ return tk_int; }
"double"	{ return tk_double; }

{ID}		{ return tk_id; }

.		{ return yytext[0]; }

%%

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