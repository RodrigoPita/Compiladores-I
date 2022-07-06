%{

void atributo_folha();

%}

DELIM   [\t\n ]
DIGITO  [0-9]
LETRA   [A-Za-z_]
DOUBLE  {DIGITO}+("."{DIGITO}+)?
ID      {LETRA}({LETRA}|{DIGITO})*
STR	    \"([^\"\n]|(\\\")|\"\")+\"|\'([^\'\n]|(\\\')|\'\')+\'
IF      [Ii][Ff]
ELSE    [Ee][Ll][Ss][Ee]
FOR     [Ff][Oo][Rr]
WHILE   [Ww][Hh][Ii][Ll][Ee]

%%

{DELIM}    { }
             
{DOUBLE}   { atributo_folha(); 
             return NUM; }

"let"	   { atributo_folha(); 
             return LET; }

"+="       { atributo_folha();
             return MAIS_IG; }

">="       { atributo_folha();
             return MAIG; }

"<="       { atributo_folha();
             return MEIG; }

"=="       { atributo_folha();
             return IG; }

{IF}       { atributo_folha();
             return IF; }

{ELSE}     { atributo_folha();
             return ELSE; }

{FOR}      { atributo_folha();
             return FOR; }

{WHILE}    { atributo_folha();
             return WHILE;}

{STR}      { atributo_folha();
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