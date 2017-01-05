#include<string.h>

struct Variable
{
    int value;
    char name[100];
    int initialized;
};

struct Variable variables[100];
int numberOfDeclaredVariables = 0;
char printBuffer[3000];

int maximum_between_two(int a, int b)
{
    if (a > b)
        return a;
    else
        return b;
}

int minimum_between_two(int a, int b)
{
    if (a < b)
        return a;
    else
        return b;
}

int greatest_common_divisor(int a, int b)
{
    while (a != b)
        if (a > b) a = a - b;
        else b = b - a;
    return b;
}

void declare_and_initialize(char x[], int v)
{
    strcpy(variables[numberOfDeclaredVariables].name, x);
    variables[numberOfDeclaredVariables].initialized = 1;
    variables[numberOfDeclaredVariables].value = v;
    ++numberOfDeclaredVariables;
}

void declare_without_initialization(char x[])
{
    strcpy(variables[numberOfDeclaredVariables].name, x);
    variables[numberOfDeclaredVariables].initialized = 0;
    ++numberOfDeclaredVariables;
}

int declared(char x[])
{
    int i;
    for (i = 0; i <= numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(x, variables[i].name))
        {
            return i;
        }
    }
    return -1;
}

void assign(char x[], int v)
{
    int p = declared(x);
    variables[p].value = v;
    variables[p].initialized = 1;
}

int initialized(char x[])
{
    int i;
    for (i = 0; i <= numberOfDeclaredVariables; i++)
    {
        if (0 == strcmp(x, variables[i].name))
        {
            if (0 == variables[i].initialized)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
    }
    return 0;
}

void addIntegerToBuffer(int number)
{
    char temp[30];
    sprintf(temp, "%d\n", number);
    strcat(printBuffer, temp);
}

void addStringToBuffer(char afisare[])
{
    strcat(printBuffer, afisare);
}

void addValueOfIdToBuffer(char x[])
{
    int p = declared(x);
    addStringToBuffer("\n id ");
    addStringToBuffer(variables[p].name);
    addStringToBuffer(" = ");
    addIntegerToBuffer(variables[p].value);
    addStringToBuffer("\n");
}

