/* Coloque aqui definições regulares */

WS	        [ \t\n]

D           [0-9]
L           [a-zA-Z_á]

ID          ({L}|"$")({L}|{D})*

INT         {D}+
FLOAT       {D}+("."{D}+)?([Ee][+\-]?{D}+)?

FOR         [Ff][Oo][Rr]
IF          [Ii][Ff]

STRING      ("\""({L}|{D}|" "|"\'"|"\\"|"\\\""|"\"\""|"/"|"\*")*"\"")|("\'"({L}|{D}|" "|"\""|"\\"|"\\\'"|"\'\'"|"/"|"\*")*"\'")
STRING2     ("`"({L}|{D}|" "|"\t"|"\n"|"\'"|"/"|"\*"|"\""|"'")*"`")

COMENTARIO  (("/*")([^*]|"\*"[^/])*("*/"))|(("//")({L}|{D}|" "|"\t"|"\*"|"/")*)



%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */

{WS}	{ /* ignora espaços, tabs e '\n' */ } 

{IF}            { return _IF; }
{FOR}           { return _FOR; }

{INT}           { return _INT; }
{FLOAT}         { return _FLOAT; }

{STRING}        { return _STRING; }
{STRING2}       { return _STRING2; }
{COMENTARIO}    { return _COMENTARIO; }

{ID}            { return _ID; }

">="            { return _MAIG; }
"<="            { return _MEIG; }
"=="            { return _IG; }
"!="            { return _DIF; }


.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */