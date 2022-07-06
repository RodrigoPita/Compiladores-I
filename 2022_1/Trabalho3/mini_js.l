%{

void atributo_folha();

%}

DELIM   [\t\n ]
DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR	\"([^\"\n]|(\\\")|\"\")+\"

%%

{DELIM}    { }
             
{DOUBLE}   { atributo_folha(); 
             return NUM; }

"let"	   { atributo_folha(); 
             return LET; }

"+="       { atributo_folha();
             return MAIS_IG; }

{STR}   { atributo_folha();
             return STR; }

{ID}       { atributo_folha(); 
             return ID; }

.          { atributo_folha();
	     return yytext[0]; }

%%

void atributo_folha() {
    yylval.c.clear();
    yylval.c.push_back( yytext );
}