all: js Teste_1.txt
	./js < Teste_1.txt

lex.yy.c: mini_js.l
	lex mini_js.l

y.tab.c: mini_js.y
	yacc mini_js.y

js: lex.yy.c y.tab.c
	g++ -o js y.tab.c -ll