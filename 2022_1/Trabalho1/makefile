all: a
	echo "\nTeste 1:"
	echo "1 1.0 1.1 2.000001 10e-9 10.34e+9 0.4e31" | ./a.out >> endl
	echo "\nTeste 2"
	echo "if ( a5 > beaba + _1 )" | ./a.out
	echo "\nTeste 3"
	echo "if( $a >= 1e-5 )" | ./a.out
	echo "\nTeste 4"
	echo " a $_ $ = "Um texto";" | ./a.out
	echo "\nTeste 5"
	echo " $ = "Uma String" "outra\t string" "d'ouro";" | ./a.out
	echo "\nTeste 6"
	echo " a = "Um \"texto" 'd\'água' 'd''ouro " ""';" | ./a.out
	echo "\nTeste 7"
	echo " a = "Um ""texto \o/ //\\/* */" ;
`  string ' "/*" '
*/ //
`;" | ./a.out
	echo "\nTeste 8"
	echo " a = 2; /* Um comentario */" | ./a.out
	echo "\nTeste 9"
	echo " a = 2; /* Um comentario */ // outro */" | ./a.out
	echo "\nTeste 10"
	echo "/* Texto
+ / * a
*/" | ./a.out

a: main.cc
	lex scan.lex
	g++ -Wall -std=c++17 main.cc -lfl

clean:
	rm a