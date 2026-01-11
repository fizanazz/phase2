%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
%}

%define parse.error verbose


/* Tokens from miniScanner.l */
%token START END
%token DATATYPE

%token AGAR AGARBHI WARNA DOHRANA
%token SHOW PAO
%token KAAM WAPAS

%token TRUEVAL FALSEVAL

%token REL_OP ASSIGN_OP ARITH_OP

%token SEMI COMMA
%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET

%token ID NUMBER CHAR_LITERAL STRING_LITERAL

/* Operator precedence (ASSIGN_OP is a token, but grammar doesn't need it for precedence) */
%left ARITH_OP

%%

program:
      START stmt_list END
    ;

stmt_list:
      stmt
    | stmt_list stmt
    ;

stmt:
      declaration
    | assignment_stmt
    | conditional
    | loop
    | function
    | output
    | input_stmt
    ;

/* Declarations */
declaration:
      DATATYPE ID SEMI
    | DATATYPE ID LBRACKET NUMBER RBRACKET SEMI
    ;

/* Assignments (with semicolon) */
assignment_stmt:
      ID ASSIGN_OP expr SEMI
    | ID LBRACKET expr RBRACKET ASSIGN_OP expr SEMI
    ;

/* Assignment without semicolon (for loop header) */
assignment_nosemi:
      ID ASSIGN_OP expr
    | ID LBRACKET expr RBRACKET ASSIGN_OP expr
    ;

/* Expressions */
expr:
      NUMBER
    | ID
    | CHAR_LITERAL
    | STRING_LITERAL
    | TRUEVAL
    | FALSEVAL
    | expr ARITH_OP expr
    ;

/* Condition */
condition:
      expr REL_OP expr
    ;

/* If / Else-if / Else */
conditional:
      AGAR LPAREN condition RPAREN LBRACE stmt_list RBRACE agarbhi_optional warna_optional
    ;

agarbhi_optional:
      AGARBHI LPAREN condition RPAREN LBRACE stmt_list RBRACE
    | %empty
    ;

warna_optional:
      WARNA LBRACE stmt_list RBRACE
    | %empty
    ;

/* Loop */
loop:
      DOHRANA LPAREN assignment_nosemi SEMI condition SEMI assignment_nosemi RPAREN
      LBRACE stmt_list RBRACE
    ;

/* Output */
output:
      SHOW LPAREN expr RPAREN SEMI
    ;

/* Input */
input_stmt:
      PAO LPAREN ID RPAREN SEMI
    | PAO LPAREN ID LBRACKET expr RBRACKET RPAREN SEMI
    ;

/* Function */
function:
      KAAM ID LPAREN param_list RPAREN
      LBRACE stmt_list WAPAS expr SEMI RBRACE
    ;

param_list:
      %empty
    | DATATYPE ID
    | param_list COMMA DATATYPE ID
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr,
            "Syntax Error | Line %d | Near '%s' | %s\n",
            yylineno,
            (yytext ? yytext : "<eof>"),
            s);
}

int main(void)
{
    printf("Parsing started...\n");
    if (yyparse() == 0)
        printf("Parsing finished: SUCCESS\n");
    else
        printf("Parsing finished: FAILED\n");
    return 0;
}
