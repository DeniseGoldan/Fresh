%{
#include <stdio.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int yylex();
int yyerror(const char * s);

%}

%token STRING ID NUMBER TRUE FALSE COMMENT
%token VAR CONST_VAR FUNCTION RETURN 
%token IF ELSE SWITCH CASE DEFAULT WHILE FOR DO BREAK CONTINUE

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

start_program : instruction_list;

instruction_list 
      : instruction_list instruction 
      | instruction
      ;

instruction
      : declaration ';'
      | expression ';'
      | flow_control
      | function_declaration ';'
      | function_definition ';'
      | object_definition ';'
      | DELETE ID ';'
      | COMMENT
      ;

/* Declaratii */
declaration
      : declarator
      | declarator EQU expression 
      ;

declarator
      : variable_type ID 
      ;

variable_type
      : CONST_VAR 
      | VAR 
      ;

/* Expressions */
expression_list
      : expression_list ',' expression
      | expression
      ;

expression
      : postfix_expression assignation_operator expression 
      | postfix_expression assignation_operator function
      | postfix_expression assignation_operator object
      | conditional_expression
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
      : logical_expression_or_or
      | logical_expression_or_or '?' expression ':' conditional_expression
      ;

logical_expression_or_or
      : logical_expression_and_and
      | logical_expression_or_or OR_OR logical_expression_and_and
      ;

logical_expression_and_and
      : logical_expression_or
      | logical_expression_and_and AND_AND logical_expression_or
      ;

logical_expression_or
      : logical_expression_xor
      | logical_expression_or OR logical_expression_xor
      ;

logical_expression_xor
      : logical_expression_and
      | logical_expression_xor XOR logical_expression_and
      ;

logical_expression_and
      : equality_expression
      | logical_expression_and AND equality_expression
      ;

equality_expression
      : relational_expression
      | equality_expression EQU_EQU relational_expression
      | equality_expression NOT_EQU relational_expression
      ;

relational_expression
      : shifting_expression
      | relational_expression GT shifting_expression
      | relational_expression GE shifting_expression
      | relational_expression LT shifting_expression
      | relational_expression LE shifting_expression
      ;

shifting_expression
      : additive_expression
      | shifting_expression SHR additive_expression
      | shifting_expression SHL additive_expression
      ;

additive_expression
      : multiplicative_expression
      | additive_expression PLU multiplicative_expression
      | additive_expression MIN multiplicative_expression
      ;

multiplicative_expression
      : unary_expression
      | multiplicative_expression TIM unary_expression
      | multiplicative_expression DIV unary_expression
      | multiplicative_expression MOD unary_expression
      ;

unary_expression
      : postfix_expression
      | unary_operator unary_expression
      | PLU_PLU unary_expression
      | MIN_MIN unary_expression
      ;

unary_operator
      : NEQU_UNAR 
      | NOT_UNAR
      | MIN
      | PLU 
      ;

postfix_expression
      : atomic_expression
      | object_construction_expression
      | postfix_expression '[' expression ']'
      | postfix_expression '(' ')'
      | postfix_expression '(' expression_list ')'
      | postfix_expression DOT ID 
      | postfix_expression PLU_PLU
      | postfix_expression MIN_MIN
      ;

object_construction_expression
      : NEW ID '(' expression_list ')'
      | NEW ID '(' ')'
      ;      

atomic_expression
      : ID 
      | STRING
      | NUMBER 
      | TRUE
      | FALSE
      | '(' expression ')'
      | '[' expression_list ']'
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
      : declarator EQU  '{' '}'
      | declarator EQU  '{' object_field_list '}'
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
      | COMMENT
      ;

object_value
      : object
      | STRING
      | NUMBER
      | TRUE
      | FALSE
      | '[' expression_list ']'
      | COMMENT
      ;

/* User defined functions */

function_declaration 
      : declarator EQU FUNCTION '(' expression_list ')'
      | declarator EQU FUNCTION '('  ')'
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
