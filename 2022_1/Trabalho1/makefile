all: a entrada.txt
	./a.out < entrada.txt	

a: main.cc
	lex scan.lex
	g++ -Wall -std=c++17 main.cc -lfl

clean:
	rm a