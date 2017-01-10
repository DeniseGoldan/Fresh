%{
#include <stdio.h>
#include "Functions.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int yylex();
int yyerror(const char * s);

%}

%union 
{
      int integer;
      char* string;
      double real;
}

%token QUOTE ID REAL INTEGER TRUE FALSE COMMENT STR INT DOUBLE
%token VAR CONST FUNCTION RETURN 
%token IF ELSE SWITCH CASE DEFAULT WHILE FOR DO BREAK CONTINUE
%token OBJECT

%type<string> variable_type
%type<string> declarator
%type<string> str_declarator
%type<integer> postfix_expression shifting_expression 
%type<integer>additive_expression multiplicative_expression unary_expression
%type<integer> atomic_expression conditional_expression logical_expression_or_or logical_expression_and_and logical_expression_or
%type<integer> expression logical_expression_xor logical_expression_and equality_expression relational_expression

%start start_program

%right EQU PLU_EQU MIN_EQU TIM_EQU DIV_EQU MOD_EQU
%left OR_OR
%left AND_AND
%left OR
%left XOR
%left AND
%left NOT_EQU EQU_EQU
%left IN GT LT LE GE
%left SHR SHL
%left PLU MIN
%left TIM DIV MOD
%right DELETE
%left PLU_PLU MIN_MIN
%nonassoc NEW
%left DOT
%nonassoc NEQU_UNAR NOT_UNAR
%nonassoc '(' ')'


%%

start_program : instruction_list {printVariableList();}
              ;

instruction_list 
      : instruction_list instruction
      | instruction
      ;

instruction
      : declaration ';'
      | str_declaration ';'
      | expression ';'
      | flow_control
      | function_declaration ';'
      | function_definition ';'
      | object_definition ';'
      | DELETE ID ';'
      | COMMENT
      ;


str_declaration
      : str_declarator
      | str_declarator EQU str_expression
      ;

str_declarator
      : STR ID { if (isDeclared($<string>2))
                                    yyerror("Already declared!");
                              addToVariableList($<string>2,"string",0);
                              $$=$<string>2;
                        }
      | CONST STR ID { if (isDeclared($<string>3))
                                    yyerror("Already declared!");
                              addToVariableList($<string>3,"string",0);
                              $$=$<string>2;
                        }
      ;

str_expression 
      : QUOTE
      | QUOTE PLU QUOTE
      | QUOTE TIM INTEGER
      | INTEGER TIM QUOTE
      ;

/* Declaratii */
declaration
      : declarator
      | declarator EQU expression {
                                    int index=getVariableIndex($1);
                                    variableList[index].initialized=1;
                                    variableList[index].value=(int*)malloc(sizeof(int));
                                    *((int*)(variableList[index].value))=$3;
                                    }
      ;

declarator
      : variable_type ID { if (isDeclared($<string>2))
                                    yyerror("Already declared!");
                              addToVariableList($<string>2,$1,0);
                              $$=$<string>2;
                        }
      | CONST variable_type ID { if (isDeclared($<string>3))
                                    yyerror("Already declared!");
                              addToVariableList($<string>3,$2,1);
                              $$=$<string>3;
                        }
      ;

variable_type
      : INT       {$$="int";}
      | DOUBLE    {$$="double";}
      ;

/* Expressions */
expression_list
      : expression_list ',' expression
      | expression
      ;

expression
      : postfix_expression assignation_operator expression {$$=$3;}
      | postfix_expression assignation_operator function
      | postfix_expression assignation_operator object
      | conditional_expression {$$=$1;}
      ;

assignation_operator
      : EQU 
      | TIM_EQU
      | DIV_EQU
      | MOD_EQU
      | PLU_EQU
      | MIN_EQU
      ;

conditional_expression
      : logical_expression_or_or {$$=$1;}
      | logical_expression_or_or '?' expression ':' conditional_expression
      ;

logical_expression_or_or
      : logical_expression_and_and {$$=$1;}
      | logical_expression_or_or OR_OR logical_expression_and_and
      ;

logical_expression_and_and
      : logical_expression_or {$$=$1;}
      | logical_expression_and_and AND_AND logical_expression_or
      ;

logical_expression_or
      : logical_expression_xor {$$=$1;}
      | logical_expression_or OR logical_expression_xor
      ;

logical_expression_xor
      : logical_expression_and {$$=$1;}
      | logical_expression_xor XOR logical_expression_and
      ;

logical_expression_and
      : equality_expression {$$=$1;}
      | logical_expression_and AND equality_expression
      ;

equality_expression
      : relational_expression {$$=$1;}
      | equality_expression EQU_EQU relational_expression
      | equality_expression NOT_EQU relational_expression
      ;

relational_expression
      : shifting_expression {$$=$1;}
      | relational_expression GT shifting_expression
      | relational_expression GE shifting_expression
      | relational_expression LT shifting_expression
      | relational_expression LE shifting_expression
      ;

shifting_expression
      : additive_expression {$$=$1;}
      | shifting_expression SHR additive_expression
      | shifting_expression SHL additive_expression
      ;

additive_expression
      : multiplicative_expression
      | additive_expression PLU multiplicative_expression {$$=$1 + $3;}
      | additive_expression MIN multiplicative_expression {$$=$1 - $3;}
      ;

multiplicative_expression
      : unary_expression {$$=$1;}
      | multiplicative_expression TIM unary_expression {$$=$1 * $3;}
      | multiplicative_expression DIV unary_expression {$$=$1 / $3;}
      | multiplicative_expression MOD unary_expression {$$=$1 % $3;}
      ;

unary_expression
      : postfix_expression {$$=$1;}
      | unary_operator unary_expression {$$=0;}
      | PLU_PLU unary_expression {$$=0;}
      | MIN_MIN unary_expression {$$=0;}
      ;

unary_operator
      : NEQU_UNAR 
      | NOT_UNAR
      | MIN
      | PLU 
      ;

postfix_expression
      : atomic_expression {$$=$1;}
      | object_construction_expression {$$=0;}
      | postfix_expression '[' expression ']' {$$=0;}
      | postfix_expression '(' ')' {$$=0;}
      | postfix_expression '(' expression_list ')' {$$=0;}
      | postfix_expression DOT ID 
      | postfix_expression PLU_PLU
      | postfix_expression MIN_MIN
      ;

object_construction_expression
      : NEW ID '(' expression_list ')'
      | NEW ID '(' ')'
      ;      

atomic_expression
      : ID {
            if (isInitialized($<string>1))
            {
                  $$=*((int*)variableList[getVariableIndex($<string>1)].value);
            }
            else
            {
                  char error[100];
                  strcpy(error,"can't use unintialized variable: ");
                  strcat(error,$<string>1);
                  yyerror(error);
            }
            }
      | QUOTE {
            $$=0;
            }
      | INTEGER {
            $$=$<integer>1;
            }
      | REAL {
            $$=0;
            }
      | TRUE {
            $$=0;
            }
      | FALSE { $$=0;
            }
      | '(' expression ')' {$$=$2;}
      | '[' expression_list ']' {$$=0;}
      ;

/* Flow control*/

flow_control
      : selection_statement
      | iteration_statement
      ;

/* Flow control : selections */
selection_statement
      : IF '(' expression ')' '{' flow_control_instruction_list '}' 
      | IF '(' expression ')' '{' flow_control_instruction_list '}' ELSE '{' flow_control_instruction_list '}'
      | SWITCH '(' expression ')' '{' switch_instruction_list '}'
      ;

flow_control_instruction_list
      : flow_control_instruction_list flow_control_instruction
      | flow_control_instruction
      ;

flow_control_instruction
      : expression ';'
      | declaration ';'
      | flow_control
      | DELETE ID ';'
      | COMMENT
      ;

switch_instruction_list
      : switch_instruction_list switch_instruction
      | switch_instruction
      ;

switch_instruction
      : CASE expression ':' flow_control_instruction_list_break
      | DEFAULT ':' flow_control_instruction_list_break
      ;

flow_control_instruction_list_break
      : flow_control_instruction_list BREAK ';'
      | flow_control_instruction_list
      | BREAK ';'
      | /* empty */
      ;

/* Flow control : iterations */
iteration_statement
      : WHILE '(' expression ')' '{' iteration_instruction_list '}' 
      | DO '{' iteration_instruction_list '}' WHILE '(' expression ')' ';'
      | FOR '(' for_instruction_list ';' for_instruction_list ';' for_instruction_list ')' '{' iteration_instruction_list '}'
      | FOR '(' variable_type ID IN expression ')' '{' iteration_instruction_list '}'
      ;

for_instruction_list
      : for_instruction_list ',' for_instruction
      | for_instruction
      ;

for_instruction
      : declaration
      | expression 
      | /* empty */
      ;

iteration_instruction_list
      : iteration_instruction_list iteration_instruction;
      | iteration_instruction
      ;

iteration_instruction
      : BREAK ';'
      | CONTINUE ';'
      | flow_control_instruction
      ;

/* User defined objects */

object_definition
      : OBJECT ID EQU  '{' '}'
      | OBJECT ID EQU  '{' object_field_list '}'
      ;

object 
      : OBJECT '{' '}'
      | OBJECT '{' object_field_list '}'

object_field_list
      : object_field_list ',' object_field
      | object_field
      ;

object_field
      : ID ':' object_value
      | COMMENT
      ;

object_value
      : object
      | QUOTE
      | INTEGER
      | REAL
      | TRUE
      | FALSE
      | '[' expression_list ']'
      | COMMENT
      ;

/* User defined functions */

function_declaration 
      : declarator EQU FUNCTION '(' expression_list ')' { printf("%s\n",$1); variableList[getVariableIndex($1)].function=1;}
      | declarator EQU FUNCTION '('  ')' {variableList[getVariableIndex($1)].function=1;}
      ;

function_definition
      : declarator EQU FUNCTION '(' expression_list ')' function_body
      | declarator EQU FUNCTION '('  ')'  function_body
      ;

function
      : FUNCTION '(' expression_list ')' function_body
      | FUNCTION '('  ')'  function_body
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
      | flow_control
      | return ';'
      | DELETE ID ';'
      | COMMENT
      ;

return
      : RETURN expression
      | RETURN
      ;


%%
int yyerror(const char * s) 
{
  printf("Error: %s at line: %d \n",s, yylineno);
  exit(1);
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
