%{ // Código em C/C++
#include <stdio.h>
#include <string>

using namespace std;

enum TOKEN { _ID = 256, _FOR, _IF, _INT, _FLOAT, _MAIG, _MEIG, _IG, _DIF, _STRING, _STRING2, _COMENTARIO };

%}

/* Coloque aqui definições regulares */
D       [0-9]
L       [ÁA-Záa-z]
S       [_$/*]

WS	[ \t\n]
STRING  (("\"")(({L}|{D}|{WS}|{S}|("\\")|("\'")|("\\\"")|("\"\""))*)("\""))|('(({L}|{D}|{WS}|{S}|("\\")|("\\\'")|("\"")|("\'\'"))*)')
STRING2 ("`")(({L}|{D}|{WS}|{S}|("\n")|("\\")|("\'")|("\""))*)+("`")
COMENTARIO (("/*")([^*]|"*"[^/])*("*/"))|(("//")(({L}|{D}|("\t")|(" ")|{S}|("+"))*))
INT     {D}+
FLOAT   {INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID      ({L}|{S})({L}|{D}|{S})*

%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */

{WS}	{ /* ignora espaços, tabs e '\n' */ } 
"if"            { return _IF; }
"iF"            { return _IF; }
"If"            { return _IF; }
"IF"            { return _IF; }

"for"           { return _FOR; }
"foR"           { return _FOR; }
"fOr"           { return _FOR; }
"fOR"           { return _FOR; }
"For"           { return _FOR; }
"FoR"           { return _FOR; }
"FOr"           { return _FOR; }
"FOR"           { return _FOR; }

{STRING}        { return _STRING; }
{STRING2}       { return _STRING2; }
{COMENTARIO}    { return _COMENTARIO; }
{INT}           { return _INT; }
{FLOAT}         { return _FLOAT; }
{ID}            { return _ID; }

">="            { return _MAIG; }
"<="            { return _MEIG; }
"=="            { return _IG; }
"!="            { return _DIF; }
.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */
