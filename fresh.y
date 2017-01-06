%{
#include "Functions.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int yylex();
int yyparse();
void checkCorectness();
int yyerror(const char * errorName);

extern struct Variable variableList[100];
extern int numberOfDeclaredVariables;
extern char printBuffer[5000];
int numberOfErrors = 0;

%}

%union 
{
  char* string_val;
  int int_val;
  double double_val;
} 

/* START symbol */
%start test_program

/* TOKENS */
%token <string_val>QUOTE <double_val>REAL <int_val> INTEGER
%token PLU MIN TIM DIV MOD INT DOUBLE STRING
%token EQU <string_val>ID
%token CONSTANT_DECLARE NORMAL_DECLARE

%%

/* The program */

test_program : instruction_list { checkCorectness(); }
             ;

instruction_list
      : instruction_list instruction
      | instruction
      ;

instruction
      : declaration ';'
      ;

/* Declarations */

declaration
      : declaration_statement { numberOfDeclaredVariables++; }
      ;

declaration_statement
      : variable_type ID 
      {
      }
      ;

variable_type
      : DOUBLE
      | STRING
      | INT
      ;

%%
int yyerror(const char * errorName)
{
    printf("Error: %s at line: %d \n", errorName, yylineno);
}

void checkCorectness()
{
    if (0 == numberOfErrors)
    {
        printf("%s", printBuffer);
    }
    else
    {
        printf("\n%s %d %s\n", "There were: ", numberOfErrors, " errors.");
    }
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        printf("Failed. You must provide a file as argument.\n");
        return 0;
    }

    yyin = fopen(argv[1],"r");
    if(NULL == yyin)
    {
        printf("Cannot open test file %s",argv[1]);
        return 0;
    }

    yyparse();

    return 0;
} 


