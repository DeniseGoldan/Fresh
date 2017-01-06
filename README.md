# Fresh
Fresh out of the oven programming language. 

The programm is made out of:

- a block where you can declare your variables (you may skip initialization).
e.g.: 
  variable a;
  variable x = 67;
  variable c;

- a block for the instructions.

You can use pre-defined functions whose logic is written in the "Functions.h" file. 
The "input" file can be used as a test. 

Steps:
1) lex fresh.l
2) yacc -d fresh.y
3) gcc lex.yy.c y.tab.c -ll -ly
4) ./a.out input
