%{
  #include <stdio.h>
  int nb_line = 1;
  int nb_column = 1;
  extern FILE *yyout;
  extern FILE *yyin;
  #include "b.tab.h"
  


  extern YYSTYPE yylval;
%}



lettre [a-zA-Z]
chiffre [0-9]+
IDF {lettre}({lettre}|{chiffre}|"_")*
ligne_comm "//".*
multicomm "/*"([^*]|"*"+[^*/])*"*"+"/"
Integer "("[-+]{chiffre}")"|{chiffre}
Float "("[-+]{chiffre}"."{chiffre}")"|({chiffre}"."{chiffre})

Message \'[^\']*\' 

%%

"PROGRAMME" { 
    
    fprintf(yyout, "mot Programme reconnu\n");
     nb_column += strlen(yytext);
      return TKPROGRAMME; }
"VAR" { 
	
	fprintf(yyout, "mot Var reconnu\n"); 
    nb_column += strlen(yytext);
	return TKVAR; }

"BEGIN" { 
    
    fprintf(yyout, "mot Begin reconnu\n");
     nb_column += strlen(yytext);
      return TKBEGIN; }
"END" { 
    
    fprintf(yyout, "mot End reconnu\n"); 
     nb_column += strlen(yytext);
    return TKEND; }
"IF" {
    
     fprintf(yyout, "mot IF reconnu\n");
      nb_column += strlen(yytext);
      return TKIF; }

"ELSE" { fprintf(yyout, "mot Else reconnu\n");
 nb_column += strlen(yytext);
  return TKELSE; }
"FOR" { fprintf(yyout, "mot For reconnu\n");
nb_column += strlen(yytext);
 return TKFOR; }
"WHILE" { fprintf(yyout, "mot While reconnu\n");
nb_column += strlen(yytext);
 return TKWHILE; }
"writeln" { fprintf(yyout, "mot writeln reconnu\n");
nb_column += strlen(yytext);
 return TKWRITELN; }
"readln" { fprintf(yyout, "mot readln reconnu\n");
nb_column += strlen(yytext);
 return TKREADLN; }
"INTEGER" { fprintf(yyout, "mot Integer reconnu\n");
nb_column += strlen(yytext);
 return TKINTEGER; }
"FLOAT" { fprintf(yyout, "mot Float reconnu\n");
nb_column += strlen(yytext);
 return TKFLOAT; }
"CONST" { fprintf(yyout, "mot Const reconnu\n");
nb_column += strlen(yytext);
 return TKCONST; }

{Integer} {
    char buffer[256];
    int num;

    if (yytext[0] == '(') {
        // Gestion des nombres signés avec parenthèses
        strncpy(buffer, yytext + 1, strlen(yytext) - 2); // Supprimer les parenthèses
        buffer[strlen(yytext) - 2] = '\0';
        num = atoi(buffer); // Convertir en entier
    } else {
        // Gestion des nombres simples
        num = atoi(yytext); // Convertir en entier
    }

    // Vérifier la plage de validité des entiers
    if (num >= -32768 && num <= 32767) {
        yylval.i_val = num;  
        insert(yytext, "const", "INTEGER", yytext , 0, 1); // Convertir en float explicitement
        fprintf(yyout, "Nombre valide %s reconnu avec valeur %d\n", yytext, num);
      
    } else {
        fprintf(yyout, "Nombre %s hors de la plage valide [-32768, 32767]\n", yytext);
    }
   return TKINTEGER_CONST;
}



{Float}    { 
     yylval.f_val = atof(yytext);
       insert(yytext, "const", "FLOAT", yytext, 0,1);  // Float
fprintf(yyout, "Nombre Float %s Reconnu\n", yytext); return TKFLOAT_CONST; }

{IDF}      { 
          yylval.s_val = strdup(yytext);
          insert(yytext, "idf", "non-type", 0, 0,0);      // IDF
fprintf(yyout, "Identifiant Reconnu %s\n", yytext); return TKIDENTIFIANT;}

{Message}  { fprintf(yyout, "Message %s Reconnu\n", yytext);
nb_column += strlen(yytext);
 return TKMESSAGE; }




[ \t] {nb_column += strlen(yytext); }
{ligne_comm} { }
{multicomm} {char *ptr = yytext;
    while (*ptr) {
        if (*ptr == '\n') { 
            nb_line++; 
            
        }
        nb_column++;
        ptr++; 
        
    }
    fprintf(yyout,"multicomm"); }
\n { nb_line++; nb_column =1;}
";" {  fprintf(yyout, "; reconnu\n");
nb_column += strlen(yytext);
 return TKSEMICOLON; }
"=" {  fprintf(yyout, "= reconnu\n");
nb_column += strlen(yytext);
 return TKEQ; }
"." {  fprintf(yyout, "Le . est reconnu\n");
nb_column += strlen(yytext);
 return TKPOINT; }
"/" {  fprintf(yyout, "Le / est reconnu\n");
nb_column += strlen(yytext);
 return TKDIV; }
"*" {  fprintf(yyout, "L' * est reconnu\n");
nb_column += strlen(yytext);
 return TKMULT; }
"{" {  fprintf(yyout, "Caractere { reconnu\n");
nb_column += strlen(yytext);
 return TKLBRACE; }
"}" {  fprintf(yyout, "Caractere } reconnu\n");
nb_column += strlen(yytext);
 return TKRBRACE; }
"(" {  fprintf(yyout, "Caractere ( reconnu\n");
nb_column += strlen(yytext);
 return TKLPAREN; }
")" {  fprintf(yyout, "Caractere ) reconnu\n");
nb_column += strlen(yytext);
 return TKRPAREN; }
"[" {  fprintf(yyout, "Caractere [ reconnu\n");
nb_column += strlen(yytext);
 return TKLBRACKET; }
"]" {  fprintf(yyout, "Caractere ] reconnu\n");
nb_column += strlen(yytext);
 return TKRBRACKET; }
"+" {  fprintf(yyout, "Caractere + reconnu\n");
nb_column += strlen(yytext);
 return TKPLUS; }
"-" {  fprintf(yyout, "Caractere - reconnu\n");
nb_column += strlen(yytext);
 return TKMINUS; }
"&" {  fprintf(yyout, "Caractere & reconnu\n");
nb_column += strlen(yytext);
 return TKAND; }
"|" {  fprintf(yyout, "Caractere | reconnu\n");
nb_column += strlen(yytext);
 return TKOR; }
"!" {  fprintf(yyout, "Caractere ! reconnu\n");
nb_column += strlen(yytext);
 return TKNEG; }
">" {  fprintf(yyout, "Caractere > reconnu\n");
nb_column += strlen(yytext);
 return TKGT; }
"<" {  fprintf(yyout, "Caractere < reconnu\n");
nb_column += strlen(yytext);
 return TKLT; }
">=" {  fprintf(yyout, "Caractere >= reconnu\n");
nb_column += strlen(yytext);
 return TKGE; }
"<=" {  fprintf(yyout, "Caractere <= reconnu\n");
nb_column += strlen(yytext);
 return TKLE; }
"==" {  fprintf(yyout, "Caractere == reconnu\n");
nb_column += strlen(yytext);
 return TKEQD; }
"!=" {  fprintf(yyout, "Caractere != reconnu\n");
nb_column += strlen(yytext);
 return TKNEQ; }
":" {  fprintf(yyout, "Caractere : reconnu\n");
nb_column += strlen(yytext);
 return TKDPOINT; }
"," {  fprintf(yyout, "Caractere , reconnu\n");
nb_column += strlen(yytext);
 return TKCOMMA; }


. { fprintf(yyout, "Erreur lexicale %s à la ligne %d et la colonne %d\n", yytext, nb_line,nb_column);}
