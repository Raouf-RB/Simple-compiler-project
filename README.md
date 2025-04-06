# Simplified Compiler Project (Lex & Yacc)

**The project created by C language** 

This is a simplified compiler project developed using  Flex (Lex) and Bison (Yacc). It demonstrates how lexical and syntactic analysis work for a custom programming language.

## 📁 Project Structure

f.l - Lexical Analyzer (created with Flex)

b.y, bm.y - Syntax Rules and Parsing (created with Bison)

q.h, s.h - Header Files

Programme.txt - Example of a program written in the input language

les commandes.txt - List of supported commands and rules

## 🚀 How to Run

1. Make sure **Flex** and **Bison** are installed on your system.

2. Open the terminal and navigate to the project directory.

3. Run the following commands:

''' bash
bison -d b.y      # Or use bm.y if you prefer alternative rules
flex f.l
gcc -o compiler lex.yy.c b.tab.c -lfl
./compiler < Programme.txt


## 📚 Project Goal

This project was developed a for educational purposes, aiming to understand how compilers work, particularly the lexical and syntactic analysis (the frontend of the compiler).

##Exemples
![Exemple photo](https://github.com/Raouf-RB/Simple-compiler-project/blob/6d49ae81a338eef9d84cf5a26ea8fe2b239ac125/Compiler-project-test.png)


## 👥 Authors

BOUSSAIDI ABDERRAOUF

HALOUI MOUSSA

DEHILI MEHDI
