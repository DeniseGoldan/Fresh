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
extern int numberOfDeclaredVariables = 0;
int numberOfErrors = 0;

%}

%union 
{
  char *string;
  int number;
} 

/* START symbol */
%start test_program

/* TOKENS */
%token PLU MIN TIM DIV MOD
%token EQU PLU_EQU MIN_EQU TIM_EQU DIV_EQU MOD_EQU
%token EQU_EQU NOT_EQU GE LE GT LT
%token OR_OR AND_AND
%token DOT
%token CONSTANT_DECLARE NORMAL_DECLARE
%token FUNCTION PRINT MAX_FUNCTION GCD_FUNCTION RETURN
%token COMMENT STRING NUMBER ID
%token IF ELSE SWITCH CASE DEFAULT FOR DO WHILE BREAK CONTINUE

/* OPERATORS precedence*/
// http://en.cppreference.com/w/cpp/language/operator_precedence
%right EQU PLU_EQU MIN_EQU TIM_EQU DIV_EQU MOD_EQU
%left OR_OR
%left AND_AND
%left NOT_EQU EQU_EQU
%left GE LE GT LT
%left PLU MIN
%left TIM DIV MOD
%left DOT

%%

/* The program */

test_program : instructions { checkCorectness(); }
             ;

instruction_list
      : instruction_list instruction
      | instruction
      ;

instruction_list
      : declaration ';'
      | expression ';'
      | flow_control_statements
      | function_definition ';'
      | object_definition ';'
      | COMMENT
      ;

/* Declarations */

declaration
      : declaration_statement { numberOfDeclaredVariables++; }
      | declaration_statement EQU expression
      {
            variabileList[numberOfDeclaredVariables].value = $<number>3;
            variabileList[numberOfDeclaredVariables].initialized = 1;
            numberOfDeclaredVariables++;
      }
      ;

declaration_statement
      : variable_type ID
      {
            if (isDeclared($<string>2))
             {
                printf("Variable %s has already been declared.\n", $<string>2);
                numberOfErrors++;
             }
             else if (isReservedWord($<string>2))
             {
                printf("Variable %s's id is a reserved word.\n", $<string>2);
                numberOfErrors++:
             }
             else
             {
                strcpy(variabileList[numberOfDeclaredVariables].id, $<string>2);
             }
      }
      ;

variable_type
      : CONSTANT_DECLARE
      | NORMAL_DECLARE
      ;

/* User defined functions*/

function_definition : declaration_statement EQU FUNCTION '(' expression_list ')' function_body
                      | declaration_statement EQU FUNCTION '('  ')'  function_body
                      ;

function_body
      : '{' '}'
      | '{' function_instruction_list '}'
      ;

function_instruction_list
      : function_instruction_list function_instruction
      | function_instruction
      ;

function_instruction
      : declaration ';'
      | expression ';'
      | flow_control_statements
      | return ';'
      | COMMENT
      ;

return
      : RETURN expression
      | RETURN
      ;

/* User defined data structures */

object_definition
      : declaration_statement EQU  '{' '}'
      | declaration_statement EQU  '{' object_field_list '}'
      ;

object
      : '{' '}'
      | '{' object_field_list '}'

object_field_list
      : object_field_list ',' object_field
      | object_field
      ;

object_field
      : ID ':' object_value
      ;

object_value
      : object
      | STRING
      | NUMBER
      | '[' expression_list ']'
      ;

/* Flow control statements ( if / if-else / switch //// while / do-while / for )*/

flow_control_statement
      : branching_statement
      | looping_statement
      ;

branching_statement
      : IF '(' expression ')' '{' branching_statement_instruction_list '}'
      | IF '(' expression ')' '{' branching_statement_instruction_list '}' ELSE '{' branching_statement_instruction_list '}'
      | SWITCH '(' expression ')' '{' switch_instruction_list '}'
      ;

branching_statement_instruction_list
      : branching_statement_instruction_list branching_statement_instruction
      | branching_statement_instruction
      ;

branching_statement_instruction
      : expression ';'
      | flow_control_statement
      | COMMENT
      ;

switch_instruction_list
      : switch_instruction_list switch_instruction
      | switch_instruction
      | COMMENT
      ;

switch_instruction
      : CASE expression ':' branching_statement_instruction_list_with_break
      | DEFAULT ':' branching_statement_instruction_list_with_break
      ;

branching_statement_instruction_list_with_break
      : branching_statement_instruction_list BREAK ';'
      | branching_statement_instruction_list ';'
      | BREAK ';'
      |
      ;

looping_statement
      : WHILE '(' expression ')' '{' looping_statement_instruction_list '}'
      | DO '{' looping_statement_instruction_list '}' WHILE '(' expression ')' ';'
      | FOR '(' for_instruction_list ';' for_instruction_list ';' for_instruction_list ')' '{' looping_statement_instruction_list '}'
      ;

looping_statement_instruction_list
      : looping_statement_instruction_list looping_statement_instruction
      | looping_statement_instruction
      ;

looping_statement_instruction
      : BREAK ';'
      | CONTINUE ';'
      | flow_control_statement
      | COMMENT
      ;

for_instruction_list
      : for_instruction_list ',' for_instruction
      | for_instruction
      ;

for_instruction
      : declaration
      | expression
      |
      ;

/* Expressions */

expression_list
      : expression_list ',' expression
      | expression
      ;

expression
      : ID assignation_operator expression
      {
            $<number>$ = $<number>3;
            int leftMemberIndex = getVariableIndex($<string>1);
            variableList[leftMemberIndex].value = $<number>3;
            variableList[leftMemberIndex].initialized = 1;
      }
      | logical_expression
      ;

assignation_operator
      : EQU
      | PLU_EG
      | MIN_EG
      | TIM_EG
      | DIV_EG
      | MOD_EG
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
        printf("\n%s %d\n", "There were: ", numberOfErrors, " errors.");
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


