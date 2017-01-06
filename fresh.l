%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%

"+"	{ return PLU; }
"-"	{ return MIN; }
"*"	{ return TIM; }
"/"	{ return DIV; }
"%"	{ return MOD; }

"="     { return EQU; }
"+="    { return PLU_EQU; }
"-="    { return MIN_EQU; }
"*="    { return TIM_EQU; }
"/="    { return DIV_EQU; }
"%="    { return MOD_EQU; }

"=="	{ return EQU_EQU; }
"!="	{ return NOT_EQU; }
">="	{ return GE; }
"<="	{ return LE; }
">"     { return GT; }
"<"     { return LT; }

"||"	{ return OR_OR; }
"&&"	{ return AND_AND; }

"."     { return DOT; }

"constant"[ ]+"variable"[ ]+    { return CONSTANT_DECLARE; }
"variable"[]+			{ return NORMAL_DECLARE; }

"function"  { return FUNCTION; }
"print"     { return PRINT; }
"max"	    { return MAX_FUNCTION };
"gcd"	    { return GCD_FUNCTION };
"return"    { return RETURN; }

"if" 		{ return IF; }
"else" 		{ return ELSE; }
"switch" 	{ return SWITCH; }
"case" 		{ return CASE; }
"default" 	{ return DEFAULT; }
"for" 		{ return FOR; }
"do" 		{ return DO; }
"while" 	{ return WHILE; }
"break" 	{ return BREAK; }
"continue"	{ return CONTINUE; }

\/\/[^\n\r]*[\n\r]		{ yylineno++; return COMMENT; }
("([^"]|"")*")                  { return STRING; }
[0-9]+|[0-9]+\.[0-9]+|\.[0-9]+	{ yylval.number = atoi(yytext); return NUMBER; }
[_a-zA-Z][_a-zA-Z0-9]* 	        { yylval.string = strdup(yytext); return ID; }

[ \t] 		;
\n 		{ yylineno++; }
. 		{ return yytext[0]; }

