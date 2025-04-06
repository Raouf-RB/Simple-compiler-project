#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdbool.h>
 
 /*Cree type pour les quadruplé */
typedef struct
{
   char op[100];
   char opd1[100];
   char opd2[100];
   char t[100];
}quadruple;
// déclaration tableau des quadruplé
quadruple QUAD [1000];
/* il déclaré extern pour acceder une variable global définie ailleurs*/
extern int qc;

void creation (char op[], char opd1[], char opd2[], char t[])
{
    strcpy(QUAD[qc].op,op);
    strcpy(QUAD[qc].opd1,opd1);
    strcpy(QUAD[qc].opd2,opd2);
    strcpy(QUAD[qc].t,t);

    qc++;
}
/* 0 pour changer le operateur , 1 pour changer operand1 , 2 pour operand2 et 3 pour t (resultat)*/
void mis_quad(int num_quad, int column_quad, char value[])
{
    switch (column_quad)
    {
    case 0 :
    strcpy(QUAD[num_quad].op,value);
       break;

    case 1 :
    strcpy(QUAD[num_quad].opd1,value);
         break;

    case 2 :
    strcpy(QUAD[num_quad].opd2,value);
         break;

    case 3 :
    strcpy(QUAD[num_quad].t,value);
         break;
    }
}

/*la ficharge les quadruplé*/
void print_quad()
{   int i ;
    printf("*********************Les Quadruplets***********************\n");

    for ( i = 0 ; i < qc ; i++)
    {
        printf("%d- (%s,%s,%s,%s)\n",i+1,QUAD[i].op,QUAD[i].opd1,QUAD[i].opd2,QUAD[i].t);
    }
       
}

void A()
{
    creation ("+","x","y","t");
    creation ("*","V","B","t");
}
