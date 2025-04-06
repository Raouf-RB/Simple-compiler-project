// Exemple d'un fichier s.h
#ifndef S_H
#define S_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdbool.h>
#include <ctype.h>







void insertion();
int search(char entity[], int t);
int insert(char entity[], char code[], char type[], char value[], int t, int bol);
void initialisation();
void afficher();
int misetableau(char entity[],char code[],char type[],int value);



// declaration type de les idfs et les constantes
typedef struct
{
    int state;
    char nom[20];
    char code[20];
    char type[20];
    // pour les ifds si constante 0 ou non constante 1
    int bol;
    float value;
} ifd_cst;

// declaration type
typedef struct
{
    int state;
    char nom[20];
    char code[20];
} sep_kw;

// declaration des tableau TS de ids et constantes
ifd_cst TS_idf_cst[1000];

// declaration  tableau Ts sep
sep_kw TS_sep[50];

// declaration tableau Ts des mots clés
sep_kw TS_kw[50];

// declaration counteur des tableau

int nb_sep = 0;
int nb_kw = 0;
int nb_idf_const = 0;

// initialisation de l'état des cases des TS
void initialisation()
{
    int i = 0;
    for (i = 0; i < 1000; i++)
        TS_idf_cst[i].state = 0;

    for (i = 0; i < 50; i++)
    {
        TS_kw[i].state = 0;
        TS_sep[i].state = 0;
    }
    insertion();
}
// declaration la fonction search pour verifier les entité s'il existe ou non dans les tableaux

int search(char entity[], int t)
{
    int i = 0;

    switch (t)
    {
    case 0:
        while (i < nb_idf_const)
        {
            if (strcmp(entity, TS_idf_cst[i].nom) == 0)
                return i; // return position
                          // else prochaine case
            i++;
        }
        return -1;

    case 1:
        while (i < nb_sep)
        {
            if (strcmp(entity, TS_sep[i].nom) == 0)
                return i;
            // else prochaine case
            i++;
        }
        return -1;

    case 2:
        while (i < nb_kw)
        {
            if (strcmp(entity, TS_kw[i].nom) == 0)
                return i;
            // else prochaine cas
            i++;
        }
        return -1;
    }
}

// declaration fonction de inserer faire rechercher dans les tableaus s'il existe ok else inserer
int insert(char entity[], char code[], char type[], char value[] , int t, int bol)
{
    
    switch (t)
    {
    case 0:
        if (search(entity, 0) == -1)
        {
            strcpy(TS_idf_cst[nb_idf_const].nom, entity);
            strcpy(TS_idf_cst[nb_idf_const].code, code);
            strcpy(TS_idf_cst[nb_idf_const].type, type);
            TS_idf_cst[nb_idf_const].value = (float)atof(value);
            TS_idf_cst[nb_idf_const].bol = bol;

            nb_idf_const++;
        }
        break;
    case 1:
        if (search(entity, 1) == -1)
        {
            strcpy(TS_sep[nb_sep].nom, entity);
            strcpy(TS_sep[nb_sep].code, code);
            TS_sep[nb_sep].state = 1;
            nb_sep++;
        }
        break;

    case 2:
        if (search(entity, 2) == -1)
        {
            strcpy(TS_kw[nb_kw].nom, entity);
            strcpy(TS_kw[nb_kw].code, code);
            TS_kw[nb_kw].state = 1;
            nb_kw++;
        }
        break;
    }
}

// fonction afficher pour afficher les 3 tableaux

void afficher()
{
   

    printf("\n/**********************Table des symboles IDF***********************");
    printf("\n--------------------------------------------------------------\n");
    printf("|    Nom    |   Code     |   Type    |    Value   |  constante | \n");
    printf("----------------------------------------------------------------\n");
    int i = 0;
    while (i < nb_idf_const)
    {
        printf("|%10s | %10s |%10s | %10.2f | %10s |\n", TS_idf_cst[i].nom, TS_idf_cst[i].code, TS_idf_cst[i].type,
               TS_idf_cst[i].value, TS_idf_cst[i].bol == 1 ? "oui" : "non");
        i++;
    }
    printf("\n/**Table des symboles Separateurs**");
    printf("\n---------------------------\n");
    printf("|    Nom    |      Code     |\n");
    printf("-----------------------------\n");
    i = 0;
    while (i < nb_sep)
    {
        printf("|%10s | %12s  |\n", TS_sep[i].nom, TS_sep[i].code);
        i++;
    }
    printf("\n/**Table des symboles mots clés**");
    printf("\n----------------------------\n");
    printf("|    Nom    |      Code     |\n");
    printf("------------------------------\n");
    i = 0;
    while (i < nb_kw)
    {
        printf("|%10s | %12s |\n", TS_kw[i].nom, TS_kw[i].code);
        i++;
    }
}
 
void insertion()
{
   insert("programme", "MC_PROGRAMME", "", 0, 2, 0);

    insert("var", "MC_VAR", "", 0, 2, 0);

    insert("brgin", "MC_BEGIN", "", 0, 2, 0);

    insert("end", "MC_END", "", 0, 2, 0);

    insert("if", "MC_IF", "", 0, 2, 0);

    insert("else", "MC_ELSE", "", 0, 2, 0);
    insert("for", "MC_FOR", "", 0, 2, 0);
    insert("while", "MC_WHILE", "", 0, 2, 0);
    insert("writeln", "MC_wrileln", "", 0, 2, 0);
    insert("readln", "MC_readln", "", 0, 2, 0);
    insert("integer", "MC_INTEGER", "", 0, 2, 0);
    insert("float", "MC_FLOAT", "", 0, 2, 0);
    insert("const", "MC_CONST", "", 0, 2, 0);

    insert(";", "Semicolon", "", 0, 1, 0);
    insert("=", "Equal", "", 0, 1, 0);
    insert(".", "Point", "", 0, 1, 0);

    insert("*", "Mult", "", 0, 1, 0);
    insert("{", "Left Brace", "", 0, 1, 0);
    insert("}", "Right Brace", "", 0, 1, 0);
    insert("(", "Left Parent", "", 0, 1, 0);
    insert(")", "Right Parent", "", 0, 1, 0);
    insert("[", "Left Bracket", "", 0, 1, 0);
    insert("]", "Right Bracket", "", 0, 1, 0);
    //insert("Left Bracket", "Left Bracket", "", 0, 1, 0);
    insert("-", "Minus", "", 0, 1, 0);
    insert("&&", "AND", "", 0, 1, 0);
    insert("||", "OR", "", 0, 1, 0);
    insert("!", "NEG", "", 0, 1, 0);
    insert(">", "Greater", "", 0, 1, 0);
    insert("<", "Lower", "", 0, 1, 0);
    insert("<=", "Great-EQ", "", 0, 1, 0);
    insert(">=", "Lower-EQ", "", 0, 1, 0);
    insert("==", "Double Equal", "", 0, 1, 0);
    insert("!=", "NEG Equal", "", 0, 1, 0);
    insert(":", "Double Point", "", 0, 1, 0);
    insert(",", "Comma", "", 0, 1, 0);
}


int compatibiliteType(const char type1[], const char type2[])
{
    if (strcmp(type1, type2) == 0)
        return 0;
    return -1;
    // si les deux type compatible return 0 vrai sion return 1 false n'est pas compatible
}

const char* CalculType(char Type1[], char Type2[]) {
     
    if (strcmp(Type1, "INTEGER") == 0 && strcmp(Type2, "INTEGER") == 0)
        return "INTEGER";
    else if ((strcmp(Type1, "INTEGER") == 0 && strcmp(Type2, "FLOAT") == 0) || 
             (strcmp(Type1, "FLOAT") == 0 && strcmp(Type2, "INTEGER") == 0))
        return "FLOAT";
    else if (strcmp(Type1, "FLOAT") == 0 && strcmp(Type2, "FLOAT") == 0)
        return "FLOAT";
    
    else
        return "non-type";
}

int  verifierAffect(char Type1[], char Type2[]) {
     
    if (strcmp(Type1, "INTEGER") == 0 && strcmp(Type2, "INTEGER") == 0)
        return 0 ;
    else if ((strcmp(Type1, "INTEGER") == 0 && strcmp(Type2, "FLOAT") == 0))
            return -1; 
    else if ((strcmp(Type1, "FLOAT") == 0 && strcmp(Type2, "INTEGER") == 0))
        return 0 ;
    else if (strcmp(Type1, "FLOAT") == 0 && strcmp(Type2, "FLOAT") == 0)
        return 0 ;
}

int CompareType(char Type1[], char Type2[], char Type3[]){
   const char *resultat =  CalculType( Type2,Type3);
   
   return compatibiliteType(Type1, resultat);


}

int misetype(char entity[],char type1[])
{
    int x = search(entity,0);//search tableau const et idfs
    if  (x != -1 && strcmp(TS_idf_cst[x].type,"non-type")== 0)
    {   
        strcpy(TS_idf_cst[x].type,type1);
        return 0; // mise a jour correct
    } 
    return -1;//
}

void returnType(char entity[],char type[10]){

    int x =  search(entity,0);
   
    strcpy(type,TS_idf_cst[x].type);
    
} 

int returnConst(char entity[]){

    int x =  search(entity,0);
   
    return TS_idf_cst[x].bol;
    
} 



int miseValue(char entity[],char value[],char type[])
{
    int x = search(entity,0);
    int k = compatibiliteType(type,TS_idf_cst[x].type); //search tableau const et idfs
    if  (x != -1 && k != -1  && TS_idf_cst[x].bol == 1 ) // if non type m3ntha ne declarer pas 
    {
        TS_idf_cst[x].value = (float)atof(value);
        return 0; // mise a jour correct
    } 
    return -1;//fausse
}

int miseConst(char entity[])
{
    int x = search(entity,0);//search tableau const et idfs
    if  (x != -1 && TS_idf_cst[x].bol == 0  )
    {
        TS_idf_cst[x].bol = 1 ;
        return 0; // mise a jour correct
    } 
    return -1;
}

int misetableau(char entity[],char code[],char type[],int value)
{
    int x = search(entity,0);
    if( x != -1 && !strcmp(TS_idf_cst[x].code,"idf") )
    {
      
        strcpy(TS_idf_cst[x].code, code);
        strcpy(TS_idf_cst[x].type, type);
        TS_idf_cst[x].value = (float)value;
        return 0;
    }
    return -1;
}

const char* detectType(const char *input) {
    int isFloat = 0, isInteger = 1;

    // Check if input is a single character
    /* if (strlen(input) == 1 && !isdigit(input[0])) {
        return "TYPE_CHAR";
    } */

    // Check for numbers
    int i;
    for ( i = 0; input[i] != '\0'; i++) {
        if (input[i] == '.' && !isFloat) {
            isFloat = 1;  // Found a dot for the first time
            isInteger = 0;
        } else if (!isdigit(input[i])) {
            return "TYPE_STRING";  // Non-digit and non-dot means it's a string
        }
    }

    if (isFloat) return "TYPE_FLOAT";
    if (isInteger) return "TYPE_INT";
    return "TYPE_UNKNOWN";
}

int indise(char entity[],int i)
{
   int x = search(entity,0);
    if (x != -1 && strcmp(TS_idf_cst[x].code,"tab")== 0 && TS_idf_cst[x].value > i)
    return 0;
    return -1;
}










#endif // S_H

