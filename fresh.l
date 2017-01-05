%{
#include<stdio.h>
#include<string.h>
#include "y.tab.h"
%}

%%

start                   {return START;}
finish                  {return FINISH;}
variable                {return VARIABLE;}
maximum_between_two     {return MAX;}
minimum_between_two     {return MIN;}
greatest_common_divisor {return GCD;}
print                   {return PRINT;}

[a-zA-Z][a-zA-Z0-9]*    {yylval.name = strdup(yytext); return ID;}
"-"?[1-9][0-9]*         {yylval.value = atoi(yytext); return NUMBER;}
[ \t] 		        ;
\n 			{yylineno++;}
. 			{return yytext[0];}

