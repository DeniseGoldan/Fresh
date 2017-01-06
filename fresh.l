%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%
"="     { 	return EQU; }
"int"	{	printf("int\n"); return INT; }
"double"	{	printf("double\n"); return DOUBLE; }
"string"	{	printf("string\n"); return STRING; }
(\"([^\"]|\"\")*\")             		{ printf("quote\n");  yylval.string_val = strdup(yytext); return QUOTE; }
0|[1-9]([0-9]*|[0-9]*\.[0-9]+|\.[0-9]+)	{ printf("real\n"); yylval.double_val = atoi(yytext); return REAL; }
0|[1-9][0-9]*							{ printf("integer\n"); yylval.int_val = atoi(yytext); return INTEGER; }
[_a-zA-Z][_a-zA-Z0-9]*	 	    		{  printf("id:%s\n",yytext); yylval.string_val = strdup(yytext); return ID; }

[ \t] 		;
\n 		{ yylineno++; }
. 		{ return yytext[0]; }

