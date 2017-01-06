#include "Functions.h"

struct Variable variableList[100];
extern int numberOfDeclaredVariables = 0;
char printBuffer[5000];

int isReservedWord(const char *nume)
{
    if (0 == strcmp(nume, "if")) { return 1; }
    if (0 == strcmp(nume, "else")) { return 1; }
    if (0 == strcmp(nume, "switch")) { return 1; }
    if (0 == strcmp(nume, "case")) { return 1; }
    if (0 == strcmp(nume, "default")) { return 1; }
    if (0 == strcmp(nume, "for")) { return 1; }
    if (0 == strcmp(nume, "do")) { return 1; }
    if (0 == strcmp(nume, "while")) { return 1; }
    if (0 == strcmp(nume, "break")) { return 1; }
    if (0 == strcmp(nume, "continue")) { return 1; }
    if (0 == strcmp(nume, "constant")) { return 1; }
    if (0 == strcmp(nume, "variable")) { return 1; }
    if (0 == strcmp(nume, "function")) { return 1; }
    if (0 == strcmp(nume, "print")) { return 1; }
    if (0 == strcmp(nume, "max")) { return 1; }
    if (0 == strcmp(nume, "gcd")) { return 1; }
    if (0 == strcmp(nume, "return")) { return 1; }

    return 0;
}

/**
 * Returns 1 if variable is declared (it appears in the variableList) and 0 otherwise.
 * */
int isDeclared(const char *id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            return 1;
        }
    }
    return 0;
}

/**
 * Returns 1 if variable is initialized and 0 otherwise.
 * */
int isInitialized(const char *id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            if (1 == variableList[i].initialized)
            {
                return 1;
            }
            break;
        }
    }
    return 0;
}
/**
 * It helps when you want to assignate the value of the right member to the left member (as in a = b;)
 * Returns -1 if variable is not found.
 * */
int getVariableIndex(const char *id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++) {
        if (0 == strcmp(id, variableList[i].id)) {
            return i;
        }
    }
    return -1;
}

/**
 * Calling print will add the value of the id inside a buffer(printBuffer).
 * The variable must be initialized. Its value can be written on up to 9 digits.
 * */
void print(const char *id) {
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            if (isInitialized(id))
            {
                char temp[10];
                sprintf(temp, "%d\n", variableList[i].value);
                strcat(printBuffer, temp);
            }
        }
    }
}

/**
 * Pre-declared functions:
 * - greatest common divisor
 * - max between 2 integers
 * */
int gcd(int a, int b)
{
    int r = a % b;
    while (r)
    {
        a = b;
        b = r;
        r = a % b;
    }
    return b;
}

int max(int a, int b)
{
    if (a >= b)
    {
        return a;
    }
    return b;
}


