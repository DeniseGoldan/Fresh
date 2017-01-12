%{
#include <stdio.h>
#include "Utility.h"
#include "Library.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int yylex();
int yyerror(const char * s);
int errors=0;

%}

%union 
{
      int integer;
      char* string;
      double real;
      struct Expression *expr;
}

%token MAX GCD PRINT
%token QUOTE ID REAL INTEGER TRUE FALSE COMMENT STR INT DOUBLE
%token VAR CONST FUNCTION RETURN 
%token IF ELSE SWITCH CASE DEFAULT WHILE FOR DO BREAK CONTINUE
%token OBJECT STRUCTURE BOOL

%type<string> variable_type
%type<string> str_declarator str_expression
%type<integer> postfix_expression
%type<expr> expression
%type<integer> additive_expression multiplicative_expression
%type<integer> atomic_expression logical_expression_or_or logical_expression_and_and int_expression
%type<integer> library_call equality_expression relational_expression
%type<integer> conditional_expression atomic_bool

%start start_program

%right EQU PLU_EQU MIN_EQU TIM_EQU DIV_EQU MOD_EQU
%left OR_OR
%left AND_AND
%left OR AND XOR
%left NOT_EQU EQU_EQU
%left IN GT LT LE GE
%left SHR SHL
%left PLU MIN
%left TIM DIV MOD
%right DELETE
%left PLU_PLU MIN_MIN
%nonassoc NEW
%left DOT
%nonassoc '(' ')'

%%

start_program : instruction_list 
              {
                  if (errors==0)
                        printf("%s",printBuffer);
              }
              ;

instruction_list 
      : instruction_list instruction
      | instruction
      ;

instruction
      : declaration ';'
      | str_declaration ';'
      | assignation ';'
      | expression ';'
      | flow_control
      | function_declaration ';'
      | function_definition
      | object_definition ';'
      | DELETE ID ';'
      | COMMENT
      | print
      ;

str_declaration
      : str_declarator
      ;

str_declarator
      : STR ID 
      { 
            if (isDeclared($<string>2))
                  yyerror("Already declared!");
            addToVariableList($<string>2,"string",0);
      }
      | CONST STR ID EQU str_expression
      {
            if (!isDeclared($<string>3))
            {
                  addToVariableList($<string>3,"string",1);
                  int index=getVariableIndex($<string>3);
                  variableList[index].value=$5;
                  variableList[index].initialized=1;
            }
            else
            {
                  yyerror(notDeclaredError($<string>3));
            }
      }
      ;

str_expression 
      : QUOTE
      {
            $$=$<string>1;
      }
      | QUOTE PLU QUOTE
      {
            $$=$<string>1;
      }
      | QUOTE TIM INTEGER
      {
            $$=$<string>1;
      }
      ;

/* Declaratii */
declaration
      : variable_type ID 
      {
            if (isDeclared($<string>2))
            {
                  yyerror(alreadyDeclaredError($<string>2));
            }
            else
            {
                  addToVariableList($<string>2,$1,0);
            }
      }
      | CONST variable_type ID EQU expression
      { 
            if (isDeclared($<string>2))
            {
                  yyerror(alreadyDeclaredError($<string>2));
            }
            else
            {
                  if (strcmp($2,$5->type)==0)
                  {
                        addToVariableList($<string>3,$2,1);
                        int index=getVariableIndex($<string>3);
                        variableList[index].value=$5->value;
                        variableList[index].initialized=1;
                  }
                  else
                  {
                        yyerror("Not appropiate type\n");
                  }  
            }
      }
      | variable_type ID '[' ']'
      {
            if (isDeclared($<string>2))
            {
                  yyerror(alreadyDeclaredError($<string>2));
            }
            else
            {
                  addToVariableList($<string>2,"table",0);
            }
      }
      ;

variable_type
      : INT       {$$="int";}
      | DOUBLE    {$$="double";}
      | BOOL      {$$="bool";}
      | OBJECT    {$$="object";}
      ;

/* Expressions */

expression 
      : int_expression
      {
            struct Expression *e = (struct Expression*)malloc(sizeof(struct Expression));
            strcpy(e->type,"int");
            e->value=(int*)malloc(sizeof(int));
            *(int*)e->value=$1;
            $$=e;
      }
      | conditional_expression
      {
            struct Expression *e = (struct Expression*)malloc(sizeof(struct Expression));
            strcpy(e->type,"bool");
            e->value=(int*)malloc(sizeof(int));
            *(int*)e->value=$1;
            $$=e;
      }
      | str_expression
      {
            struct Expression *e = (struct Expression*)malloc(sizeof(struct Expression));
            strcpy(e->type,"string");
            e->value=(int*)malloc(sizeof(char)*strlen($1));
            e->value=$1;
            $$=e;
      }
      ;

assignation
      : ID assignation_operator int_expression 
      {
            if (isDeclared($<string>1))
            {
                  int index=getVariableIndex($<string>1);
                  if (strcmp(variableList[index].type,"int")!=0)
                  {
                        yyerror(invalidTypeError($<string>1,"int"));
                  }
                  else
                  {
                        if (variableList[index].constant==1)
                        {
                               yyerror(declaredConstant($<string>1));            
                        }
                        else
                        {
                              variableList[index].initialized=1;
                              variableList[index].value=(int*)malloc(sizeof(int));
                              *((int*)(variableList[index].value))=$3;
                        }
                  }
            }
            else
            {
                  yyerror(notDeclaredError($<string>1));
            }
      }
      | ID assignation_operator NEW ID 
      {
            if (isDeclared($<string>1))
            {
                  int index=getVariableIndex($<string>4);
                  if (strcmp(variableList[index].type,"structure")!=0)
                  {
                        yyerror(invalidTypeError($<string>1,"structure"));
                  }
                  else
                  {
                        int index1=getVariableIndex($<string>1);
                        variableList[index1].initialized=1;
                  }
            }
            else
            {
                  yyerror(notDeclaredError($<string>1));
            }
      }
      | ID assignation_operator conditional_expression
      {
            if (isDeclared($<string>1))
            {
                  int index=getVariableIndex($<string>1);
                  if (strcmp(variableList[index].type,"bool")!=0)
                  {
                        yyerror(invalidTypeError($<string>1,"bool"));
                  }
                  else
                  {
                        variableList[index].initialized=1;
                        variableList[index].value=(int*)malloc(sizeof(int));
                        *((int*)(variableList[index].value))=$3;
                  }
            }
            else
            {
                  yyerror(notDeclaredError($<string>1));
            }
      }
      | ID assignation_operator str_expression
      { 
      }
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
      | logical_expression_or_or '?' expression ':' conditional_expression {$$=$1;}
      ;

logical_expression_or_or
      : logical_expression_and_and {$$=$1;}
      | logical_expression_or_or OR_OR logical_expression_and_and
      ;

logical_expression_and_and
      : equality_expression {$$=$1;}
      | atomic_bool
      | logical_expression_and_and AND_AND equality_expression
      ;

atomic_bool
      : TRUE {$$=0;}
      | FALSE {$$=1;}
      ;

equality_expression
      : relational_expression {$$=$1;}
      | equality_expression EQU_EQU relational_expression
      | equality_expression NOT_EQU relational_expression
      ;

relational_expression
      : atomic_expression GT atomic_expression {$$=0;}
      | atomic_expression GE atomic_expression {$$=0;}
      | atomic_expression LT atomic_expression {$$=0;}
      | atomic_expression LE atomic_expression {$$=0;}
      ;

int_expression
      : additive_expression
      | int_expression OR additive_expression
      ;

additive_expression
      : multiplicative_expression
      | additive_expression PLU multiplicative_expression {$$=$1 + $3;}
      | additive_expression MIN multiplicative_expression {$$=$1 - $3;}
      ;

multiplicative_expression
      : postfix_expression {$$=$1;}
      | multiplicative_expression TIM postfix_expression {$$=$1 * $3;}
      | multiplicative_expression DIV postfix_expression {$$=$1 / $3;}
      | multiplicative_expression MOD postfix_expression {$$=$1 % $3;}
      ;

postfix_expression
      : atomic_expression {$$=$1;}
      | postfix_expression DOT ID 
      | postfix_expression PLU_PLU
      | postfix_expression MIN_MIN
      ;      

atomic_expression
      : ID 
      {
            if (isDeclared($<string>1))
            {
                  int index=getVariableIndex($<string>1);
                  if (strcmp(variableList[index].type,"int")!=0)
                  {
                        yyerror(invalidTypeError($<string>1,"int"));
                  }
                  else
                  {
                        if (isInitialized($<string>1))
                        {

                              $$=*((int*)variableList[getVariableIndex($<string>1)].value);
                        }
                        else
                        {
                              yyerror(notInitializedError($<string>1));
                        }
                  }
            }
            else
             {
                  yyerror(notDeclaredError($<string>1));
            }
      }
      | INTEGER 
      {
            $$=$<integer>1;
      }
      | REAL 
      {
            $$=$<real>1;
      }
      | ID '(' expression ')' 
      {
            if (isDeclaredFunction($<string>1))
            {
                  int index = getFunctionIndex($<string>1);
                  if (functionList[index].defined==0)
                  {
                       yyerror(notDefinedFunctionError($<string>1));
                  }
                  else
                  {
                        $$=0;
                  }
            }
            else
            {
                  yyerror(notDeclaredFunctionError($<string>1));
            }
      }
      | library_call
      {
            $$=$1;
      }
      ;

/* Flow control*/

flow_control
      : selection_statement
      | iteration_statement
      ;

/* Flow control : selections */
selection_statement
      : IF '(' conditional_expression ')' '{' flow_control_instruction_list '}' 
      | IF '(' conditional_expression ')' '{' flow_control_instruction_list '}' ELSE '{' flow_control_instruction_list '}'
      | SWITCH '(' int_expression ')' '{' switch_instruction_list '}'
      ;

flow_control_instruction_list
      : flow_control_instruction_list flow_control_instruction
      | flow_control_instruction
      ;

flow_control_instruction
      : assignation ';'
      | print
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
      | 
      ;

/* Flow control : iterations */
iteration_statement
      : WHILE '(' conditional_expression ')' '{' iteration_instruction_list '}' 
      | DO '{' iteration_instruction_list '}' WHILE '(' conditional_expression ')' ';'
      | FOR '(' for_instruction_list ';' conditional_expression ';' for_instruction_list ')' '{' iteration_instruction_list '}'
      ;

for_instruction_list
      : for_instruction_list ',' for_instruction
      | for_instruction
      ;

for_instruction
      : declaration
      | assignation 
      | COMMENT
      |
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
      : STRUCTURE ID '{' '}' 
      { 
            if (isDeclared($<string>2))
            {
                 yyerror(alreadyDeclaredError($<string>2));
            }
            else
            {
                  addToVariableList($<string>2,"structure",0);
            }
      }
      | STRUCTURE ID  '{' object_field_list '}' 
      { 
            if (isDeclared($<string>2))
            {
                  yyerror(alreadyDeclaredError($<string>2));
            }
            else
            {
                  addToVariableList($<string>2,"structure",0);
            }
      }
      ;

object_field_list
      : object_field_list ',' object_field
      | object_field
      ;

object_field
      : declaration
      ;

/* User defined functions */

parameter_list_definition: declaration ',' parameter_list_definition
            | declaration
            ;

parameter_list_declaration : variable_type ',' parameter_list_declaration
                        | variable_type
                        ;


function_declaration 
      : FUNCTION variable_type ID '(' parameter_list_declaration ')'
      {
            if (isDeclaredFunction($<string>3))
            {
                  yyerror(alreadyDeclaredFunctionError($<string>2));
            }
            else
            {
                  addToFunctionList($<string>3,$2);
            }
      }
      | FUNCTION variable_type ID '('  ')'
      {
            if (isDeclaredFunction($<string>3))
            {
                  yyerror(alreadyDeclaredFunctionError($<string>2));
            }
            else
            {
                  addToFunctionList($<string>3,$2);
            }
      }
      ;

function_definition
      : FUNCTION variable_type ID '(' parameter_list_definition ')' function_body
      {
            if (isDeclaredFunction($<string>3))
            {
                  yyerror(alreadyDeclaredFunctionError($<string>2));
            }
            else
            {
                  addToFunctionList($<string>3,$2);
                  functionList[getFunctionIndex($<string>3)].defined=1;
            }
      }
      | FUNCTION variable_type ID '('  ')'  function_body
      {
            if (isDeclaredFunction($<string>3))
            {
                  yyerror(alreadyDeclaredFunctionError($<string>2));
            }
            else
            {
                  addToFunctionList($<string>3,$2);
                  functionList[getFunctionIndex($<string>3)].defined=1;
            }
      }
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

library_call : MAX '(' expression ',' expression ')' 
             {
                  if (strcmp($3->type,"int") || strcmp($5->type,"int"))
                  {
                        yyerror(invalidTypeError("One parameter ","int"));
                  }
                  else
                  {
                        $$=max(*(int*)($3->value),*(int*)($5->value));
                  }
             }
             | GCD '(' expression ',' expression ')' 
             {
                  if (strcmp($3->type,"int") || strcmp($5->type,"int"))
                  {
                        yyerror(invalidTypeError("One parameter ","int"));
                  }
                  else
                  {
                        $$=gcd(*(int*)($3->value),*(int*)($5->value));
                  }
             }
        ;

print : PRINT '(' int_expression ')' ';'
      {
            print($3);
      }


%%
int yyerror(const char * s) 
{
      errors=1;
      printf("Error %s at line: %d \n",s, yylineno);
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
