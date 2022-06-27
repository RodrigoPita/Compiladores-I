all: a entrada.txt
	./a.out < entrada.txt

lex.yy.c: js.lex
	lex js.lex

y.tab.c: js.y
	yacc js.y

js: lex.yy.c y.tab.c
	g++ -o js y.tab.c -lfl