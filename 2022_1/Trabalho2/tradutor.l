
WS	[ \n\t]
D	[0-9]
L	[A-Za-z_]

INT	{D}+

NUM {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

STRING	("\""({L}|{D}|"!"|","|":"|" "|"\'"|"\\"|"\\\""|"\"\""|"/"|"\*")*"\"")

ID	{L}({L}|{D})*
FUNC {ID}"("

%%

{WS}		{ /* ignora espaços, tabs e '\n' */ }

{STRING} 	{ return tk_string; }
{INT}       { return tk_cte_int; }
{NUM}   	{ return tk_cte_double; }
"print" 	{ return tk_print; }
{FUNC}    { return tk_func; }
{ID}		  { return tk_id; }

.		{ return yytext[0]; }

%%