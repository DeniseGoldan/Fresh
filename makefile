all:
	lex fresh.l
	yacc -d fresh.y
	gcc lex.yy.c y.tab.c -ll -ly

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out