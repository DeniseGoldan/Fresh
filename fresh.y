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
%token PLU MIN TIM DIV MOD INT DOUBLE STRING CONST
%token EQU <string_val>ID
%token CONSTANT_DECLARE NORMAL_DECLARE
%type <string_val>variable_type
%type <int_val>int_expression

%%

/* The program */

test_program : instruction_list { checkCorectness(); printTable();}
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
      :  variable_type ID 
      {
        strcpy(variableList[numberOfDeclaredVariables].id,$2);
        strcpy(variableList[numberOfDeclaredVariables].type,$1);
        variableList[numberOfDeclaredVariables].constant=0;
        variableList[numberOfDeclaredVariables].value=NULL;
      }
      | CONST variable_type ID EQU int_expression
      {
        strcpy(variableList[numberOfDeclaredVariables].id,$3);
        strcpy(variableList[numberOfDeclaredVariables].type,$2);
        variableList[numberOfDeclaredVariables].constant=1;
        variableList[numberOfDeclaredVariables].value=&$5;
      }
      ;

variable_type
      : DOUBLE {$$="double";}
      | STRING {$$="string";}
      | INT {$$="int";}
      ;

int_expression:
    INTEGER {$$=$<int_val>1;}
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


