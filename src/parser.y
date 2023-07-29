%code requires{
  #include "ast.hpp"
  #include <cassert>
  #include <iostream>

  extern const Node *g_root; // A way of getting the AST out

  //! This is to fix problems when generating C++
  // We are declaring the functions provided by Flex, so
  // that Bison generated code can call them.
  int yylex(void);
  void yyerror(const char *);
}

 // Represents the value associated with any kind of
 // AST node.
%union{
  const Node *node;
  Declarator *declarator_node;
  double number;
  std::string *string;
}

 /* ----------------------------------------------------------          Tokens           -------------------------------------------------------------- */

 // Arithmetic operators
%token T_TIMES T_DIVIDE T_PLUS T_MINUS
 // Character Operators
%token T_LBRACKET T_RBRACKET T_LCBRACKET T_RCBRACKET T_SEMICOLON T_ASSIGNMENT
 // Types operators
%token T_INT
 // Control flow operators
%token T_RETURN
 // Stuff
%token IDENTIFIER INT_LITERALS

 /* ----------------------------------------------------------          Types           -------------------------------------------------------------- */

%type <node>   function_definition primary_expression compound_statement statement_list declaration_specifier type_specifier
%type <node>   statement expression_statement jump_statement expression assignment_expression unary_expression postfix_expression
%type <declarator_node>  declarator direct_declarator
%type <number> INT_LITERALS
%type <string> IDENTIFIER

%start ROOT

%%


ROOT : function_definition { g_root = $1;}

function_definition
    : declaration_specifier declarator compound_statement { $$ = new FunctionDefinition($2, $3); }
    ;

 /*  type of stuff */
declaration_specifier
    : type_specifier { $$ = $1; }
    ;

 /*$$ = new PrimitiveType(INT);*/
type_specifier
    : T_INT { ; }
    ;

 /* name of stuff (variable / function etc) */
declarator
    : direct_declarator { $$ = $1; }
    ;

direct_declarator
    : IDENTIFIER                                { $$ = new Declarator(*$1); }
    | direct_declarator T_LBRACKET T_RBRACKET   { $$ = $1; }
    ;

compound_statement
    : T_LCBRACKET statement_list T_RCBRACKET    { $$ = $2; }
    /* : T_LCBRACKET T_RCBRACKET                   { scope stuff } */
    ;

 /* Assuming only one statement */
statement_list
    : statement                     { $$ = $1; }
    /* | statement_list statement */
    ;

statement
    : jump_statement            { $$ = $1; }
    /* : compound_statement        { $$ = $1; }
    | expression_statement      { $$ = $1; }
    */
    ;

expression_statement
    : T_SEMICOLON               { ; }
    | expression T_SEMICOLON    { $$ = $1; }
    ;

jump_statement
    : T_RETURN expression T_SEMICOLON   { $$ = new Return($2); }
    ;

expression
    : assignment_expression     { $$ = $1; }
    ;

assignment_expression
    : unary_expression                                      { $$ = $1; }
    | unary_expression T_ASSIGNMENT assignment_expression
    ;

unary_expression
    : postfix_expression    { $$ = $1; }
    ;

postfix_expression
    : primary_expression                       { $$ = $1; }
    ;

primary_expression
    : INT_LITERALS        { $$ = new Integer($1); }
	/* | IDENTIFIER          { $$ = new Identifier(*$1); }
	   | CONSTANT
	| STRING_LITERAL
	| '(' expression ')' */
	;

%%



const Node *g_root; // Definition of variable (to match declaration earlier)

const Node *parseAST()
{
  g_root=NULL;
  yyparse();
  return g_root;
}
