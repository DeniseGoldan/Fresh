all:
	lex limbaj.l
	yacc -d limbaj.y
	gcc lex.yy.c y.tab.c -ll -ly

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out 