%option noyywrap

%{
// Avoid error "error: `fileno' was not declared in this scope"
extern "C" int fileno(FILE *stream);

// #include "parser.tab.hpp"
#include "token_test.hpp"

%}

D			    [0-9]
L               [a-zA-Z_]

%%

"int"           { return T_INT; }
"return"        { return T_RETURN; }

"("             { return T_LBRACKET; }
")"             { return T_RBRACKET; }
"{"             { return T_LCBRACKET; }
"}"             { return T_RCBRACKET; }

"*"             { return T_TIMES; }
"+"             { return T_PLUS; }
"/"             { return T_DIVIDE; }
"-"             { return T_MINUS; }

"="             { return T_ASSIGNMENT; }

";"             { return T_SEMICOLON; }

{L}({L}|{D})*   { yylval.wordValue = new std::string(yytext); return IDENTIFIER; }
{D}+            { yylval.numberValue = atoi(yytext); return INT_LITERALS; }


[ \t\r\n]+		{;}

.               { fprintf(stderr, "Invalid token\n"); exit(1); }
%%

void yyerror (char const *s)
{
  fprintf (stderr, "Parse error : %s\n", s);
  exit(1);
}
