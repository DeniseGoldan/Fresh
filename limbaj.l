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

"function" { return FUNCTION; }
"return" { return RETURN; }
"structure" { return STRUCTURE; }
"object" {return OBJECT;}

"max"     	{return MAX;}
"gcd" 		{return GCD;}
"print"		{return PRINT;}

"bool" {return BOOL;}

\/\/[^\r\n]*[\r\n] { yylineno++; return COMMENT; }
0|[1-9][0-9]* {yylval.integer = atoi(yytext); return INTEGER;}
(0|[1-9][0-9]*)[\.]?[0-9]* { yylval.real = atoi(yytext); return REAL;}
(\"(\\.|[^\\"])*\")|(\'(\\.|[^\\'])*\') { yylval.string = strdup(yytext); return QUOTE; }

"const" { return CONST; } 
"var" {return VAR; }
"str" {return STR; }
"int" {return INT;}
"double" {return DOUBLE;}
[a-zA-Z$_][a-zA-Z0-9$_]* {yylval.string=strdup(yytext); return ID;}

[ \t] {};
\n {yylineno++;}
. {return yytext[0];}
