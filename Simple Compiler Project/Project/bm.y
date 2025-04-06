%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyout;
extern FILE *yyin;
#include "s.h"
#include "q.h"
void yyerror(const char *s);
int yylex(void);
char sauvType[25];
char sauvType2[25];
int valeur;
int pas;
char tmpexp [10];
char tmpexp2 [10];
char var[10];
char varexp[10];
char sauvcst[20];
char sauvType3[10];
int Fin_if=0,deb_else=0,deb_for=0,fin_for=0,deb_while=0,fin_while=0;
int qc=0;
int val=0,val2=0;
char tmp [20];
char tmp1 [20];
char tmp2 [20];
char tmp3 [20];
char vartype [10];
char sauvidf[8];
int sauvidf2=0,demidf=0;
extern int nb_line ;
extern int nb_column;
%}

%union {
    int i_val;
    float f_val;
    char* s_val;
}

%token <s_val> TKIDENTIFIANT
%token <s_val> TKMESSAGE
%token <i_val> TKINTEGER_CONST
%token <f_val> TKFLOAT_CONST
%token TKPROGRAMME TKVAR TKBEGIN TKEND TKCONST
%token TKIF TKELSE TKFOR TKWHILE 
%token TKINTEGER TKFLOAT
%token TKPLUS TKMINUS TKMULT TKDIV
%token TKEQD TKNEQ TKLT TKLE TKGT TKGE TKEQ TKAND TKOR
%token TKLPAREN TKRPAREN TKLBRACE TKRBRACE TKSEMICOLON TKCOMMA TKPOINT TKDPOINT
%token TKLBRACKET TKRBRACKET
%token TKWRITELN TKREADLN

%expect-rr 3

%type <s_val> type
%type <s_val> declarations declaration
%type <s_val> instructions instruction
%type <i_val> expression
%type <s_val> program


%left TKNEG
%left TKAND TKOR
%left TKEQD TKNEQ TKLT TKLE TKGT TKGE
%right TKUMINUS
%left TKMULT TKDIV
%left TKPLUS TKMINUS
%nonassoc TKERROR

%%

program : TKPROGRAMME TKIDENTIFIANT TKVAR TKLBRACE declarations TKRBRACE TKBEGIN instructions TKEND TKPOINT
        {
            fprintf(yyout,"Programme %s analysé avec succès.\n", $2);
        }
        ;

declarations : declaration declarations
             | {}
             | error %prec TKERROR{}
             ;

declaration : type TKIDENTIFIANT FinDec
            {
                strcpy(vartype,$1);

                if(misetype($2,$1) == -1)
                //error semantique
                printf("error semantique double declaration a la line %d et la colonne %d ",nb_line,nb_column);
                fprintf(yyout, ("-Declaration\n"));
            }
            | type TKIDENTIFIANT TKLBRACKET TKINTEGER_CONST TKRBRACKET FinDecTab
            {
                
                fprintf(yyout, ("-Declaration Tableau\n"));
            }
            | TKCONST TKIDENTIFIANT TKEQ TKINTEGER_CONST TKSEMICOLON
            {
                if(misetype($2,"INTEGER") == -1)
                //error semantique
                printf("error semantique double declaration a la line %d et la colonne %d \n",nb_line,nb_column);
                fprintf(yyout, ("-Declaration d'une Constante entiere\n"));
            }
            | TKCONST TKIDENTIFIANT TKEQ TKFLOAT_CONST TKSEMICOLON
            {
                if(misetype($2,"FLOAT") == -1)
                //error semantique
                printf("error semantique double declaration a la line %d et la colonne %d \n",nb_line,nb_column);
                fprintf(yyout, ("-Declaration d'une Constante float\n"));
            }
            | error %prec TKERROR{}
            ;

FinDec : TKCOMMA TKIDENTIFIANT FinDec {
    if(misetype($2,vartype) == -1)
                //error semantique
                printf("error semantique double declaration a la line %d et la colonne %d ",nb_line,nb_column);
                fprintf(yyout, ("-Multiple Declaration\n"));
}
|TKSEMICOLON {}

FinDecTab : TKCOMMA TKIDENTIFIANT TKLBRACKET TKINTEGER_CONST TKRBRACKET FinDecTab
            |TKSEMICOLON

type : TKINTEGER { fprintf(yyout, ("-INTEGER\n")); $$ = "INTEGER"}
     | TKFLOAT   { fprintf(yyout, ("-FLOAT\n")); $$ = "FLOAT"}
     | error %prec TKERROR{}
     ;

instructions : instruction instructions
             | {}
             | error %prec TKERROR{}
             ;

instruction : TKIDENTIFIANT TKEQ expression TKSEMICOLON
            {
                fprintf(yyout, ("-Affectation\n"));
            }
            | IF
            | WHILE 
            | FOR 
            | TKWRITELN TKLPAREN TKMESSAGE TKRPAREN TKSEMICOLON
            {
                printf("Écriture sur écran : %s\n", $3);
                fprintf(yyout,("-Instruction Writeln\n"));
            }
            | TKREADLN TKLPAREN TKIDENTIFIANT TKRPAREN TKSEMICOLON
            {
                printf("Lecture dans la variable : %s\n", $3);
                fprintf(yyout, ("-Instruction Readln\n"));
            }
            | error %prec TKERROR{}
            ;

IF : A ELSE {if(val2==1){ // Si il y'a un else
    val2=0;
    fprintf(yyout, ("-Structure Conditionnelle IF-ELSE\n"));
    creation("vide","","temp code else", "vide"); // Temporaire du code else
    sprintf(tmp,"%d",qc); 
    mis_quad(deb_else,1,tmp); 
    sprintf(tmp,"%d",qc+1); 
    mis_quad(Fin_if,1,tmp);}

    else{
        fprintf(yyout, ("-Structure Conditionnelle IF\n")); // si il n y'a pas de else 

        }
};


A : B TKLBRACE instructions TKRBRACE {
    creation("vide","","temp code", "vide"); // Temporaire du code then
    Fin_if=qc;
    creation("BR", "","vide", "vide");
};
B : TKIF TKLPAREN expression TKRPAREN {
    deb_else=qc; 
    creation("BZ", "","temp_cond", "vide");
};
ELSE : TKELSE TKLBRACE instructions TKRBRACE {
    val2=1;
};


WHILE : X TKLBRACE instructions TKRBRACE {
    fprintf(yyout, ("-Boucle While\n"));
    creation("vide","","temp code", "vide");
    sprintf(tmp,"%d",deb_while);
    creation("BR",tmp ,"vide", "vide");
	sprintf(tmp,"%d",qc+1);
    mis_quad(fin_while,1,tmp);
}
X : Y TKLPAREN expression TKRPAREN{
    fin_while=qc;
    creation("BNZ","","cond.temp", "");
}
Y : TKWHILE{deb_while=qc;}

FOR : L TKRPAREN TKLBRACE instructions TKRBRACE {
    fprintf(yyout, ("-Boucle Pour\n"));      // Notre compilateur a reduit et donc reconnu une structure for
    creation("vide","","temp code", "vide"); // Temporaire du code
    sprintf(tmp1,"%d",pas);                  // On met le pas dans tmp1 et on cast son type vers char
    creation("+",tmp1,var,"temp");           // On genere le quadruple qui met a jour la somme selon le pas
    creation("=","temp","","var");           // on met a jour la valeur de notre variable 
    sprintf(tmp,"%d",deb_for);               // On cast le num du quad de debut de la condition
    creation("BR",tmp,"cond.temp", "");      // Branchement vers le debut de la condition
    sprintf(tmp,"%d",qc+1);                  // Cast de l'adresse de fin
    mis_quad(fin_for,1,tmp);                 // On met-a-jour le quand qui envoie vers la fin si la condition est fausse
}
L : M expression {
    fin_for=qc;                              // On enregistre l'adresse de ce quadruple car on devra y inserer l'adresse de fin du for
    creation("BZ","","cond.temp","");// Quad qui verifie si la condition est fausse et effectue un branchement vers fin si necessaire
}
M : TKFOR TKLPAREN TKIDENTIFIANT TKDPOINT expression TKDPOINT expression TKDPOINT {
    deb_for=qc;                              // On sauvegarde l'adresse du debut aka addresse du debut de la condition
    pas = $7;                                // on sauvegarde notre pas
    strcpy(var,$3);                          //On enregistre le nom de notre variable
}

expression : TKIDENTIFIANT {fprintf(yyout, ("-Identifiant reconnu\n"));}
            | TKINTEGER_CONST { $$ = $1; fprintf(yyout, ("-Affectation Int\n"));}
            | TKFLOAT_CONST { $$ = $1; fprintf(yyout, ("-Affectation Float\n"));}
            | expression TKPLUS expression { 
                $$ = $1 + $3; 
                fprintf(yyout, ("-Addition\n"));
                sprintf(tmpexp,"%d",$1);
                sprintf(tmpexp2,"%d",$3);
                
                creation("+",tmpexp,tmpexp2,"temp");
                creation("=","temp","","result");
            }
            | expression TKMINUS expression { 
                $$ = $1 - $3; 
                fprintf(yyout, ("-Soustraction\n"));
                fprintf(yyout, ("-Addition\n"));
                sprintf(tmpexp,"%d",$1);
                sprintf(tmpexp2,"%d",$3);
                
                creation("-",tmpexp,tmpexp2,"temp");
                creation("=","temp","","result");
            }
            | expression TKMULT expression { 
                $$ = $1 * $3; 
                fprintf(yyout, ("-Produit\n"));
                fprintf(yyout, ("-Addition\n"));
                sprintf(tmpexp,"%d",$1);
                sprintf(tmpexp2,"%d",$3);
                
                creation("*",tmpexp,tmpexp2,"temp");
                creation("=","temp","","result");
            }
            | expression TKDIV expression
            {
                if ($3 == 0) {
                    yyerror("Division par zéro");
                } else {
                    $$ = $1 / $3;
                    fprintf(yyout, ("-Addition\n"));
                    sprintf(tmpexp,"%d",$1);
                    sprintf(tmpexp2,"%d",$3);
                
                    creation("/",tmpexp,tmpexp2,"temp");
                    creation("=","temp","","result");
                }
                fprintf(yyout, ("-Quotient\n"));
            }
            | TKLPAREN expression TKRPAREN { fprintf(yyout, ("-Expression Parenthesee\n"));}
            | expression TKLT expression { $$ = ($1 < $3) ? 1 : 0; fprintf(yyout, ("-Comparaison Inferieure\n"));}
            | expression TKGT expression { $$ = ($1 > $3) ? 1 : 0; fprintf(yyout, ("-Comparaison Superieure\n"));}
            | expression TKLE expression { $$ = ($1 <= $3) ? 1 : 0; fprintf(yyout, ("-Comparaison Inferieure ou egale\n"));}
            | expression TKGE expression { $$ = ($1 >= $3) ? 1 : 0; fprintf(yyout, ("-Comparaison Superieure ou egale\n"));}
            | expression TKEQD expression { $$ = ($1 == $3) ? 1 : 0; fprintf(yyout, ("-Comparaison Egalite\n"));}
            | expression TKNEQ expression { $$ = ($1 != $3) ? 1 : 0; fprintf(yyout, ("-Non-Egalite\n"));}
            | expression TKAND expression { fprintf(yyout, ("-Et Logique\n"));}
            | expression TKOR expression { fprintf(yyout, ("-Ou Logique\n"));}
            | error %prec TKERROR{}
            ;

%%

void yyerror(const char *s) {
    fprintf(yyout, "Erreur : %s à la ligne %d\n", s, nb_line);
    yyclearin;
}

int main(void) {
    yyin = fopen("Programme.txt", "r");
    if (yyin == NULL) {
        fprintf(yyout,"ERROR: Unable to open input file\n");
        return 1;
    }

    yyout = fopen("result.txt", "w");
    if (yyout == NULL) {
        fprintf(yyout,"ERROR: Unable to open output file\n");
        fclose(yyin);
        return 1;
    }
    initialisation();
    
    yyparse();
    afficher();
    print_quad();
    fclose(yyin);
    fclose(yyout);
    return 0;

}