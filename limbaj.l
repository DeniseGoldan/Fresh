%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

"if" { return IF; }
"while" { return WHILE; }
"switch" { return SWITCH; }
"for" { return FOR; }
"do" { return DO; }
"else" { return ELSE; }
"case" { return CASE; }
"default" { return DEFAULT; }
"break" { return BREAK; }
"continue" { return CONTINUE; }

"true" { return TRUE; }
"false" { return FALSE; }

"new" { return NEW; }
"delete" { return DELETE; }
"in" { return IN; }

"." { return DOT; }

"^" { return XOR; }
"&" { return AND; }
"|" { return OR; }

">>" { return SHR; }
"<<" { return SHL; }

"+" { return PLU; }
"-" { return MIN; }
"*" { return TIM; }
"/" { return DIV; }
"%" { return MOD; }

"+=" { return PLU_EQU; }
"-=" { return MIN_EQU; }
"=" { return EQU;}
"*=" { return TIM_EQU;}
"/=" { return DIV_EQU;}
"%=" { return MOD_EQU;}

"||" { return OR_OR; }
"&&" { return AND_AND; }

"==" { return EQU_EQU; }
"!=" { return NOT_EQU; }

">=" { return GE; }
"<=" { return LE; }
"<" { return LT; }
">" { return GT; }

"--" { return MIN_MIN; }
"++" { return PLU_PLU; }

"~" { return NEQU_UNAR; } 
"!" { return NOT_UNAR; }

"function" { return FUNCTION; }
"return" { return RETURN; }

\/\/[^\r\n]*[\r\n] { yylineno++; return COMMENT; }
[0-9]+[\.]?[0-9]* { yylval = atoi(yytext); return NUMBER;}
(\"(\\.|[^\\"])*\")|(\'(\\.|[^\\'])*\') { return QUOTE; }

"const"[ ]+"var" { return CONST_VAR; } // I've used [ ]+ so that I cound add multiPLUe spaces
"var" {return VAR; }
"str" {return STR; }
[a-zA-Z$_][a-zA-Z0-9$_]* { return ID;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
