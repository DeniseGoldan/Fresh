#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int numberOfDeclaredVariables = 0;
char printBuffer[5000];

struct Variable
{
    char id[255];
    char type[255];
    void* value;
    int constant;
};

struct Variable variableList[100];

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

int printTable()
{
    int i=0;
    for (i=0; i < numberOfDeclaredVariables; ++i)
    {
        printf("---------NEW VARIABLE---------\n");
        printf("ID:%s \n",variableList[i].id);
        printf("TYPE:%s \n ",variableList[i].type);

        if (NULL != variableList[i].value)
        {
            if (strcmp(variableList[i].type,"int")==0)
            {
                printf("VALUE:%d \n",*(int*)(variableList[i].value));
            }
        }
        else 
        {
            printf("VALUE: not initialized \n");
        }

        if (1 == variableList[i].constant)
        {
            printf("CONSTANT :yes \n");
        }
        else
        {
            printf("CONSTANT: no \n");
        }
        printf("--------------------------");


    }
}

int isInitialized(const char *id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            if (variableList[i].value!=NULL)
            {
                return 1;
            }
            break;
        }
    }
    return 0;
}
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

void print(const char* id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            if (isInitialized(id))
            {
                char temp[10];
                //sprintf(temp, "%d\n", variableList[i].value);
                strcat(printBuffer, temp);
            }
        }
    }
}

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

#endif //FUNCTIONS_H
