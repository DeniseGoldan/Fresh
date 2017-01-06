#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Variable
{
    char id[255];
    int value;
    int initialized;
};

int isReservedWord(const char *id);
int isDeclared(const char *id);
int isInitialized(const char *id);
int getVariableIndex(const char *id);

void print(const char* id);

int max(int, int);
int gcd(int, int);

#endif //FUNCTIONS_H

