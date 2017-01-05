%{
#include <stdio.h>
#include "Functions.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int numberOfErrors = 0;
%}

%token VARIABLE MAX MIN GCD PRINT NUMBER ID START FINISH
%union
{
    int value;
    char *name;
}
%type<name> ID
%type<value> NUMBER function expression
%start test_program
%left '+' '-'
%left '*' '/'

%%
test_program : declarations instructions {if(0 == numberOfErrors){printf("%s",printBuffer);printf("Your test program was syntactically correct.\n");}else{printf("Your test program had %d errors.\n", numberOfErrors);}};

declarations :  declaration ';'
    	   | declarations declaration ';'
     	   ;

declaration : VARIABLE ID {if(declared($2)==-1)declare_without_initialization($2);else {yyerror();printf("This variable has not been declared yet.\n");}}
   		   | VARIABLE ID '=' NUMBER {if(declared($2)==-1)declare_and_initialize($2,$4);else {yyerror(); printf("This variable has not been declared yet.\n");}}
           ;

instructions : START block FINISH
     		 ;

block :  instruction ';'
     | block instruction ';'
     ;

instruction : ID '=' expression {if(-1 == declared($1)){yyerror();printf("This variable has not been declared yet.\n");} else assign($1,$3);}
             | PRINT '(' NUMBER ')' {if(0 == numberOfErrors){addIntegerToBuffer($3);}}
             | PRINT '(' ID ')' {if(-1 == declared($3)){yyerror();printf("This variable has not been declared yet.\n");} else if (0 == initialized($3)){yyerror();printf("This variable has not been initialized yet.\n");}else if(0 == numberOfErrors){addValueOfIdToBuffer($3);}  }
             ;

expression : expression '+' expression {$$=$1+$3;}
		   | expression '-' expression {$$=$1-$3;}
		   | expression '*' expression {$$=$1*$3;}
		   | expression '/' expression {$$=$1/$3;}
		   | NUMBER {$$=$1;}
		   | ID {if(-1 == declared($1)){yyerror();printf("This variable has not been declared yet.\n");}$$=variables[declared($1)].value;}
		   | function {$$=$1;}
		   ;

function : MAX '(' expression ',' expression ')' {$$=maximum_between_two($3,$5);}
        | MIN '(' expression ',' expression ')' {$$=minimum_between_two($3,$5);}
        | GCD '(' expression ',' expression ')' {$$=greatest_common_divisor($3,$5);}
        ;
%%

int yyerror(const char * s)
{
 	printf("Error: %s at line number %d.\n", s, yylineno);
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        printf("Running the test failed. You must provide a file as argument.\n");
        return 0;
    }

    yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}
