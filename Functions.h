#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int numberOfDeclaredVariables = 0;
int numberOfDeclaredFunctions = 0;
char printBuffer[5000];
char errorBuffer[5000];

struct Variable
{
    char id[255];
    char type[255];
    void* value;
    int initialized;
    int constant;
};

struct Function
{
    char id[255];
    char returnType[255];
    int defined;
};

struct Variable variableList[100];
struct Function functionList[100];

void addToFunctionList(const char* id,const char* type)
{
    strcpy(functionList[numberOfDeclaredFunctions].id,id);
    strcpy(functionList[numberOfDeclaredFunctions].returnType,type);
    functionList[numberOfDeclaredFunctions].defined=0;

    numberOfDeclaredFunctions++;
}

void addToVariableList(const char* id,const char* type,int constant)
{
    strcpy(variableList[numberOfDeclaredVariables].id,id);
    strcpy(variableList[numberOfDeclaredVariables].type,type);
    variableList[numberOfDeclaredVariables].constant=constant;
    variableList[numberOfDeclaredVariables].initialized=0;

    numberOfDeclaredVariables++;
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

int isDeclaredFunction(const char *id)
{

    int i;
    for (i = 0; i < numberOfDeclaredFunctions; i++)
    {
        if (0 == strcmp(id, functionList[i].id))
        {
            return 1;
        }
    }
    return 0;
}

void printVariableList()
{
    int i=0;
    for (i=0; i < numberOfDeclaredVariables; ++i)
    {
        printf("---------NEW VARIABLE---------\n");
        printf("ID: %s \n",variableList[i].id);
        printf("TYPE: %s \n",variableList[i].type);

        if (variableList[i].initialized==1)
        {
            if (strcmp(variableList[i].type,"int")==0)
                printf("VALUE: %d\n",*(int*)variableList[i].value);
            else if (strcmp(variableList[i].type,"double")==0)
                printf("VALUE: %d\n",*(int*)variableList[i].value);
            else if (strcmp(variableList[i].type,"string")==0)
                printf("VALUE: %s\n",(char*)variableList[i].value);
            else if (strcmp(variableList[i].type,"bool")==0)
                printf("VALUE: %s\n",(char*)variableList[i].value);
            else   
                printf("VALUE: initialized \n");
        }
        else 
        {
            printf("VALUE: not initialized \n");
        }

        if (1 == variableList[i].constant)
        {
            printf("CONSTANT: yes \n");
        }
        else
        {
            printf("CONSTANT: no \n");
        }
        printf("------------------------------\n");
    }
}

void printFunctionList()
{
    int i=0;
    for (i=0; i < numberOfDeclaredFunctions; ++i)
    {
        printf("---------NEW FUNCTION---------\n");
        printf("ID: %s \n",functionList[i].id);
        printf("RETURN TYPE: %s \n",functionList[i].returnType);

        if (functionList[i].defined==1)
        {
                printf("Defined\n");
        }
        else 
        {
            printf("Not defined\n");
        }
        printf("------------------------------\n");
    }
}

int isInitialized(const char *id)
{
    int i;
    for (i = 0; i < numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(id, variableList[i].id))
        {
            if (variableList[i].value!=NULL || variableList[i].initialized==1)
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
    for (i = 0; i < numberOfDeclaredVariables; i++)
     {
        if (0 == strcmp(id, variableList[i].id)) 
        {
            return i;
        }
    }
    return -1;
}

int getFunctionIndex(const char* id)
{
    int i;
    for (i = 0; i < numberOfDeclaredFunctions; i++)
     {
        if (0 == strcmp(id, functionList[i].id)) 
        {
            return i;
        }
    }
    return -1;
}

void print(int value)
{
    char temp[20];
    sprintf(temp, "%d\n", value);
    strcat(printBuffer, temp);
}

char* notDeclaredFunctionError(char* id)
{
    char error[100];
    strcpy(error,"Function not declared:");
    strcat(error,id);

    return strdup(error);
}

char* notDeclaredError(char* id)
{
    char error[100];
    strcpy(error,"Variable not declared:");
    strcat(error,id);

    return strdup(error);
}

char* invalidTypeError(char* id,char* type)
{
    char error[100];
    strcpy(error,"Invalid type:");
    strcat(error,id);
    strcat(error,"Not an ");
    strcat(error,type);
    
    return strdup(error);
}

char* alreadyDeclaredError(char* id)
{
    char error[100];
    strcpy(error,"Variable already declared:");
    strcat(error,id);

    return strdup(error);
}

char* alreadyDeclaredFunctionError(char* id)
{
    char error[100];
    strcpy(error,"Function already declared:");
    strcat(error,id);

    return strdup(error);
}


char* notInitializedError(char* id)
{
    char error[100];
    strcpy(error,"Variable not initialized:");
    strcat(error,id);

    return strdup(error);
}

char* notDefinedFunctionError(char* id)
{
    char error[100];
    strcpy(error,"Function not defined yet:");
    strcat(error,id);

    return strdup(error);
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