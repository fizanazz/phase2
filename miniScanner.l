cat > miniScanner.l <<'EOF'
%option noyywrap yylineno

%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%

"shuru"      { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return START; }
"khatam"     { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return END; }

"Adad"       { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }
"ChhotaAdad" { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }
"BaraAdad"   { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }
"Harf"       { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }
"Jumla"      { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }
"Haqeeqat"   { printf("%-4d | %-17s | %s\n", yylineno,"DATATYPE",yytext); return DATATYPE; }

"agar"       { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return AGAR; }
"agarbhi"    { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return AGARBHI; }
"warna"      { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return WARNA; }
"dohrana"    { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return DOHRANA; }
"likho"      { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return SHOW; }
"paao"       { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return PAO; }
"kaam"       { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return KAAM; }
"wapas"      { printf("%-4d | %-17s | %s\n", yylineno,"KEYWORD",yytext); return WAPAS; }

"trueval"    { printf("%-4d | %-17s | %s\n", yylineno,"BOOLEAN",yytext); return TRUEVAL; }
"falseval"   { printf("%-4d | %-17s | %s\n", yylineno,"BOOLEAN",yytext); return FALSEVAL; }

"=="         { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }
"!="         { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }
"<="         { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }
">="         { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }
"<"          { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }
">"          { printf("%-4d | %-17s | %s\n", yylineno,"REL_OP",yytext); return REL_OP; }

"="          { printf("%-4d | %-17s | %s\n", yylineno,"ASSIGN_OP",yytext); return ASSIGN_OP; }

"+"          { printf("%-4d | %-17s | %s\n", yylineno,"ARITH_OP",yytext); return ARITH_OP; }
"-"          { printf("%-4d | %-17s | %s\n", yylineno,"ARITH_OP",yytext); return ARITH_OP; }
"*"          { printf("%-4d | %-17s | %s\n", yylineno,"ARITH_OP",yytext); return ARITH_OP; }
"/"          { printf("%-4d | %-17s | %s\n", yylineno,"ARITH_OP",yytext); return ARITH_OP; }

";"          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return SEMI; }
","          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return COMMA; }
"("          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return LPAREN; }
")"          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return RPAREN; }
"{"          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return LBRACE; }
"}"          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return RBRACE; }
"["          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return LBRACKET; }
"]"          { printf("%-4d | %-17s | %s\n", yylineno,"PUNCTUATION",yytext); return RBRACKET; }

"//".*       { /* ignore comments */ }

\'([^'\n\\]|\\.)\' {
    printf("%-4d | %-17s | %s\n", yylineno,"CHAR_LITERAL",yytext);
    return CHAR_LITERAL;
}

\"([^"\n\\]|\\.)*\" {
    printf("%-4d | %-17s | %s\n", yylineno,"STRING_LITERAL",yytext);
    return STRING_LITERAL;
}

[0-9]+(\.[0-9]+)? {
    printf("%-4d | %-17s | %s\n", yylineno,"NUMBER",yytext);
    return NUMBER;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("%-4d | %-17s | %s\n", yylineno,"IDENTIFIER",yytext);
    return ID;
}

[ \t\r\n]+   ;

. {
    fprintf(stderr, "Lexical Error | Line %d | Unknown character '%s'\n", yylineno, yytext);
}

%%
