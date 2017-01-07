%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
%}

%%
"="     { return EQU; }

"const"		{ return CONST; }

"int"	    { return INT; }
"double"	{ return DOUBLE; }
"string"	{ return STRING; }

(\"([^\"]|\"\")*\")             { yylval.string_val = strdup(yytext); return QUOTE; }
[0-9]*\.[0-9]+|\.[0-9]+	        { yylval.double_val = atoi(yytext); return REAL; }
0|[1-9][0-9]*					{ yylval.int_val = atoi(yytext); return INTEGER; }
[_a-zA-Z][_a-zA-Z0-9]*	 	    { yylval.string_val = strdup(yytext); return ID; }

[ \t] 		;
\n 		{ yylineno++; }
. 		{ return yytext[0]; }

