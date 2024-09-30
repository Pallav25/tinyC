%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyC2_22CS30040_22CS30048.h"
int yylex(void);
%}

%code requires{
    struct node {
        char* id;
        struct node* firstchild;
        struct node* nextsibling;
    };
}

%union {
    int num;
    char *id;
    struct node* nodep;
}

%token <id> ID CONSTANT STRING
%token <id> SIZEOF VOID CHAR SHORT INT LONG FLOAT DOUBLE SIGNED UNSIGNED BOOL COMPLEX IMAGINARY
%token <id> EXTERN STATIC AUTO REGISTER CONST RESTRICT VOLATILE
%token <id> INLINE
%token <num> IF ELSE SWITCH CASE DEFAULT WHILE FOR DO GOTO CONTINUE BREAK RETURN
%token <num> ARROW INCREMENT DECREMENT LOGICAL_AND GREATER_EQUAL LESS_EQUAL LEFT_SHIFT RIGHT_SHIFT EQUAL NOT_EQUAL LOGICAL_OR
%token <num> AMPERSAND ASTERISK PLUS MINUS TILDE EXCLAMATION CARET VERTICAL_BAR QUESTION_MARK COLON SEMICOLON
%token <num> ASSIGN MULTIPLY_ASSIGN_1 DIVIDE_ASSIGN MODULO_ASSIGN PLUS_ASSIGN MINUS_ASSIGN LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN
%token <num> AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token <num> LEFT_PAREN RIGHT_PAREN LEFT_BRACKET RIGHT_BRACKET LEFT_BRACE RIGHT_BRACE DOT
%token <num> COMMA ELLIPSIS FORWARD_SLASH PERCENT HASH LESS_THAN GREATER_THAN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start starting_point

%type <nodep> primary_expression postfix_expression argument_expression_list_opt argument_expression_list unary_expression unary_operator
%type <nodep> cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression
%type <nodep> AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression
%type <nodep> conditional_expression assignment_expression assignment_operator expression constant_expression
%type <nodep> declaration declaration_specifiers storage_class_specifier type_specifier type_qualifier function_specifier
%type <nodep> declaration_specifiers_opt init_declarator_list_opt init_declarator_list init_declarator declarator pointer_opt
%type <nodep> pointer type_qualifier_list_opt type_qualifier_list direct_declarator identifier_list_opt
%type <nodep> identifier_list assignment_expression_opt parameter_type_list parameter_list parameter_declaration abstract_declarator_opt
%type <nodep> abstract_declarator direct_abstract_declarator parameter_type_list_opt type_name specifier_qualifier_list
%type <nodep> specifier_qualifier_list_opt initializer designation_opt designation designator_list 
%type <nodep> designator initializer_list declaration_list_opt declaration_list
%type <nodep> statement labeled_statement compound_statement block_item_list_opt block_item_list block_item expression_statement
%type <nodep> expression_opt selection_statement iteration_statement jump_statement starting_point translation_unit
%type <nodep> external_declaration function_definition




%%

/* Grammar rules start here */

primary_expression:
    ID { $$= create_leaf($1); }
  | CONSTANT { $$= create_leaf($1); }
  | STRING { $$= create_leaf($1); }
  | LEFT_PAREN expression RIGHT_PAREN { $$= create_root(create_leaf("("),"primary_expression"); addchild($$, $2); addchild($$, create_leaf(")")); }
  ;

postfix_expression:
    primary_expression { $$= create_root($1,"postfix_expression"); }
  | postfix_expression LEFT_BRACKET expression RIGHT_BRACKET { $$= create_root($1,"postfix_expression"); addchild($$,create_leaf("[")); addchild($$, $3); addchild($$, create_leaf("]")); }
  | postfix_expression LEFT_PAREN argument_expression_list_opt RIGHT_PAREN { $$= create_root($1,"postfix_expression"); addchild($$,create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); }
  | postfix_expression DOT ID { $$= create_root($1,"postfix_expression"); addchild($$, create_leaf(".")); addchild($$, create_leaf($3)); }
  | postfix_expression ARROW ID { $$= create_root($1,"postfix_expression"); addchild($$,create_leaf("->")); addchild($$,create_leaf($3)); }
  | postfix_expression INCREMENT { $$= create_root($1,"postfix_expression"); addchild($$, create_leaf("++")); }
  | postfix_expression DECREMENT { $$= create_root($1,"postfix_expression"); addchild($$, create_leaf("--")); }
  | LEFT_PAREN type_name RIGHT_PAREN LEFT_BRACE initializer_list RIGHT_BRACE { $$= create_root(create_leaf("("),"postfix_expression"); addchild($$, $2); addchild($$, create_leaf(")")); addchild($$, create_leaf("{")); addchild($$, $5); addchild($$, create_leaf("}")); }
  | LEFT_PAREN type_name RIGHT_PAREN LEFT_BRACE initializer_list COMMA RIGHT_BRACE { $$= create_root(create_leaf("("),"postfix_expression"); addchild($$, $2); addchild($$, create_leaf(")")); addchild($$, create_leaf("{")); addchild($$, $5); addchild($$, create_leaf(",")); addchild($$, create_leaf("}")); }
  ;

argument_expression_list_opt:
    argument_expression_list { $$= $1; }
  | /* empty */   {$$=create_leaf("NULL");}
  ;

argument_expression_list:
    assignment_expression { $$= create_root($1,"argument_expression_list"); }
  | argument_expression_list COMMA assignment_expression { $$= create_root($1,"argument_expression_list"); addchild($$, create_leaf(",")); addchild($$, $3); }
  ;

unary_expression:
    postfix_expression { $$= create_root($1,"unary_expression"); }
  | INCREMENT unary_expression { $$= create_root(create_leaf("++"),"unary_expression"); addchild($$, $2); }
  | DECREMENT unary_expression { $$= create_root(create_leaf("--"),"unary_expression"); addchild($$, $2); }
  | unary_operator cast_expression { $$= create_root($1,"unary_expression"); addchild($$, $2); }
  | SIZEOF unary_expression { $$= create_root(create_leaf($1),"unary_expression"); addchild($$, $2); }
  | SIZEOF LEFT_PAREN type_name RIGHT_PAREN { $$= create_root(create_leaf($1),"unary_expression"); addchild($$,create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); }
  ;

unary_operator:
    AMPERSAND { $$= create_leaf("%"); }
  | ASTERISK { $$= create_leaf("*"); }
  | PLUS { $$= create_leaf("+"); }
  | MINUS { $$= create_leaf("-"); }
  | TILDE { $$= create_leaf("~"); }
  | EXCLAMATION { $$= create_leaf("!"); }
  ;

cast_expression:
    unary_expression { $$= create_root($1,"cast_expression"); }
  | LEFT_PAREN type_name RIGHT_PAREN cast_expression { $$= create_root(create_leaf("("),"cast_expression"); addchild($$, $2); addchild($$, create_leaf(")")); addchild($$, $4); }
  ;

multiplicative_expression:
    cast_expression { $$= create_root($1,"multiplicative_expression"); }
  | multiplicative_expression ASTERISK cast_expression  { $$= create_root($1,"multiplicative_expression"); addchild($$, create_leaf("*")); addchild($$, $3); }
  | multiplicative_expression FORWARD_SLASH cast_expression { $$= create_root($1,"multiplicative_expression"); addchild($$, create_leaf("/")); addchild($$, $3); }
  | multiplicative_expression PERCENT cast_expression { $$= create_root($1,"multiplicative_expression"); addchild($$, create_leaf("%")); addchild($$, $3); }
  ;

additive_expression:
    multiplicative_expression { $$= create_root($1,"additive_expression"); }
  | additive_expression PLUS multiplicative_expression { $$= create_root($1,"additive_expression"); addchild($$, create_leaf("+")); addchild($$, $3); }
  | additive_expression MINUS multiplicative_expression { $$= create_root($1,"additive_expression"); addchild($$, create_leaf("-")); addchild($$, $3); }
  ;

shift_expression:
    additive_expression { $$= create_root($1,"shift_expression"); }
  | shift_expression LEFT_SHIFT additive_expression { $$= create_root($1,"shift_expression"); addchild($$, create_leaf("<<")); addchild($$, $3); }
  | shift_expression RIGHT_SHIFT additive_expression { $$= create_root($1,"shift_expression"); addchild($$, create_leaf(">>")); addchild($$, $3); }
  ;

relational_expression:
    shift_expression { $$= create_root($1,"relational_expression"); }
  | relational_expression LESS_THAN shift_expression { $$= create_root($1,"relational_expression"); addchild($$, create_leaf("<")); addchild($$, $3); }
  | relational_expression GREATER_THAN shift_expression { $$= create_root($1,"relational_expression"); addchild($$, create_leaf(">")); addchild($$, $3); }
  | relational_expression LESS_EQUAL shift_expression { $$= create_root($1,"relational_expression"); addchild($$, create_leaf("<=")); addchild($$, $3); }
  | relational_expression GREATER_EQUAL shift_expression { $$= create_root($1,"relational_expression"); addchild($$, create_leaf(">=")); addchild($$, $3); }
  ;

equality_expression:
    relational_expression { $$= create_root($1,"equality_expression"); }
  | equality_expression EQUAL relational_expression { $$= create_root($1,"equality_expression"); addchild($$, create_leaf("==")); addchild($$, $3); }
  | equality_expression NOT_EQUAL relational_expression { $$= create_root($1,"equality_expression"); addchild($$, create_leaf("!=")); addchild($$, $3); }
  ;

AND_expression:
    equality_expression { $$= create_root($1,"AND_expression"); }
  | AND_expression AMPERSAND equality_expression    { $$= create_root($1,"AND_expression"); addchild($$, create_leaf("&")); addchild($$, $3); }
  ;

exclusive_OR_expression:
    AND_expression  { $$= create_root($1,"exclusive_OR_expression"); }
  | exclusive_OR_expression CARET AND_expression    { $$= create_root($1,"exclusive_OR_expression"); addchild($$, create_leaf("^")); addchild($$, $3); }
  ;

inclusive_OR_expression:
    exclusive_OR_expression { $$= create_root($1,"inclusive_OR_expression"); }
  | inclusive_OR_expression VERTICAL_BAR exclusive_OR_expression    { $$= create_root($1,"inclusive_OR_expression"); addchild($$, create_leaf("|")); addchild($$, $3); }
  ;

logical_AND_expression:
    inclusive_OR_expression { $$= create_root($1,"logical_AND_expression"); }
  | logical_AND_expression LOGICAL_AND inclusive_OR_expression  { $$= create_root($1,"logical_AND_expression"); addchild($$, create_leaf("&&")); addchild($$, $3); }
  ;

logical_OR_expression:
    logical_AND_expression  { $$= create_root($1,"logical_OR_expression"); }
  | logical_OR_expression LOGICAL_OR logical_AND_expression   { $$= create_root($1,"logical_OR_expression"); addchild($$, create_leaf("||")); addchild($$, $3); }
  ;

conditional_expression:
    logical_OR_expression   { $$= create_root($1,"conditional_expression"); }
  | logical_OR_expression QUESTION_MARK expression COLON conditional_expression { $$= create_root($1,"conditional_expression"); addchild($$, create_leaf("?")); addchild($$, $3); addchild($$, create_leaf(":")); addchild($$, $5); }
  ;

assignment_expression:
    conditional_expression  { $$= create_root($1,"assignment_expression"); }
  | unary_expression assignment_operator assignment_expression  { $$= create_root($1,"assignment_expression"); addchild($$, $2); addchild($$, $3); }
  ;

assignment_operator:
    ASSIGN  { $$= create_leaf("="); }
  | MULTIPLY_ASSIGN_1   { $$= create_leaf("*="); }
  | DIVIDE_ASSIGN   { $$= create_leaf("/="); }
  | MODULO_ASSIGN   { $$= create_leaf("%="); }
  | PLUS_ASSIGN  { $$= create_leaf("+="); }
  | MINUS_ASSIGN    { $$= create_leaf("-="); }
  | LEFT_SHIFT_ASSIGN   { $$= create_leaf("<<="); }
  | RIGHT_SHIFT_ASSIGN  { $$= create_leaf(">>="); }
  | AND_ASSIGN  { $$= create_leaf("&="); }
  | XOR_ASSIGN  { $$= create_leaf("^="); }
  | OR_ASSIGN   { $$= create_leaf("|="); }
  ;

expression:
    assignment_expression   { $$= create_root($1,"expression"); }
  | expression COMMA assignment_expression      { $$= create_root($1,"expression"); addchild($$, create_leaf(",")); addchild($$, $3); }
  ;

constant_expression:
    conditional_expression  { $$= create_root($1,"constant_expression"); }
  ;

declaration:
    declaration_specifiers init_declarator_list_opt SEMICOLON   { $$= create_root($1,"declaration"); addchild($$, $2); addchild($$, create_leaf(";")); }
  ;

declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt  { $$= create_root($1,"declaration_specifiers"); addchild($$, $2); } 
  | type_specifier declaration_specifiers_opt   { $$= create_root($1,"declaration_specifiers"); addchild($$, $2); }
  | type_qualifier declaration_specifiers_opt   { $$= create_root($1,"declaration_specifiers"); addchild($$, $2); }
  | function_specifier declaration_specifiers_opt   { $$= create_root($1,"declaration_specifiers"); addchild($$, $2); }
  ;

storage_class_specifier:
    EXTERN  { $$= create_leaf($1); }
  | STATIC  { $$= create_leaf($1); }
  | AUTO    { $$= create_leaf($1); }
  | REGISTER    { $$= create_leaf($1); }
  ;

type_specifier:
    VOID    { $$= create_leaf($1); }
  | CHAR    { $$= create_leaf($1); }
  | SHORT   { $$= create_leaf($1); }
  | INT     { $$= create_leaf($1); } 
  | LONG    { $$= create_leaf($1); }
  | FLOAT   { $$= create_leaf($1); }
  | DOUBLE  { $$= create_leaf($1); }
  | SIGNED  { $$= create_leaf($1); }
  | UNSIGNED    { $$= create_leaf($1); }
  | BOOL    { $$= create_leaf($1); }
  | COMPLEX { $$= create_leaf($1); }
  | IMAGINARY   { $$= create_leaf($1); }
  ;

type_qualifier:
    CONST   { $$= create_leaf($1); }
  | RESTRICT  { $$= create_leaf($1); }
  | VOLATILE    { $$= create_leaf($1); }
  ;

function_specifier:
    INLINE  { $$= create_leaf($1); }
  ;

declaration_specifiers_opt:
    declaration_specifiers  { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

init_declarator_list_opt:
    init_declarator_list    { $$=$1;}
  | /* empty */ {$$=create_leaf("NULL");}
  ;

init_declarator_list:
    init_declarator { $$= create_root($1,"init_declarator_list"); }
  | init_declarator_list COMMA init_declarator  { $$= create_root($1,"init_declarator_list"); addchild($$, create_leaf(",")); addchild($$, $3); }
  ;

init_declarator:
    declarator  { $$= create_root($1,"init_declarator"); }
  | declarator ASSIGN initializer   { $$= create_root($1,"init_declarator"); addchild($$, create_leaf("=")); addchild($$, $3); }
  ;

declarator:
    pointer_opt direct_declarator   { $$= create_root($1,"declarator"); addchild($$, $2); }
  ;

pointer_opt:
    pointer { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

pointer:
    ASTERISK type_qualifier_list_opt pointer { $$= create_root(create_leaf("*"),"pointer"); addchild($$, $2); addchild($$, $3); }
  | ASTERISK type_qualifier_list_opt { $$= create_root(create_leaf("*"),"pointer"); addchild($$, $2); }
  ;

type_qualifier_list_opt:
    type_qualifier_list   { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

type_qualifier_list:
    type_qualifier  { $$= create_root($1,"type_qualifier_list"); }
  | type_qualifier_list type_qualifier  { $$= create_root($1,"type_qualifier_list"); addchild($$, $2); }
  ;

direct_declarator:
    ID  { $$= create_leaf($1); }
  | LEFT_PAREN declarator RIGHT_PAREN   { $$= create_root(create_leaf("("),"direct_declarator"); addchild($$, $2); addchild($$, create_leaf(")")); }
  | direct_declarator LEFT_BRACKET type_qualifier_list_opt assignment_expression_opt RIGHT_BRACKET  { $$= create_root($1,"direct_declarator"); addchild($$, create_leaf("[")); addchild($$, $3); addchild($$, $4); addchild($$, create_leaf("]")); }
  | direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN    { $$= create_root($1,"direct_declarator"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); }
  | direct_declarator LEFT_PAREN identifier_list_opt RIGHT_PAREN    { $$= create_root($1,"direct_declarator"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); }
  ;

identifier_list_opt:
    identifier_list { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

identifier_list:
    ID  { $$= create_leaf($1); }
  | identifier_list COMMA ID    { $$= create_root($1,"identifier_list"); addchild($$, create_leaf(",")); addchild($$, create_leaf($3)); }
  ;

assignment_expression_opt:
    assignment_expression  { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

parameter_type_list:
    parameter_list  { $$= create_root($1,"parameter_type_list"); }
  | parameter_list COMMA ELLIPSIS   { $$= create_root($1,"parameter_type_list"); addchild($$, create_leaf(",")); addchild($$, create_leaf("...")); }
  ;

parameter_list:
    parameter_declaration   { $$= create_root($1,"parameter_list"); }
  | parameter_list COMMA parameter_declaration  { $$= create_root($1,"parameter_list"); addchild($$, create_leaf(",")); addchild($$, $3); }
  ;

parameter_declaration:
    declaration_specifiers declarator   { $$= create_root($1,"parameter_declaration"); addchild($$, $2); }
  | declaration_specifiers abstract_declarator_opt  { $$= create_root($1,"parameter_declaration"); addchild($$, $2); }
  ;

abstract_declarator_opt:
    abstract_declarator { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

abstract_declarator:
    pointer     { $$= create_root($1,"abstract_declarator"); }
  | pointer_opt direct_abstract_declarator  { $$= create_root($1,"abstract_declarator"); addchild($$, $2); }
  ;

direct_abstract_declarator:
    LEFT_PAREN abstract_declarator RIGHT_PAREN  { $$= create_root(create_leaf("("),"direct_abstract_declarator"); addchild($$, $2); addchild($$, create_leaf(")")); }
  | LEFT_BRACKET assignment_expression_opt RIGHT_BRACKET    { $$= create_root(create_leaf("["),"direct_abstract_declarator"); addchild($$, $2); addchild($$, create_leaf("]")); }
  | direct_abstract_declarator LEFT_BRACKET assignment_expression_opt RIGHT_BRACKET { $$= create_root($1,"direct_abstract_declarator"); addchild($$, create_leaf("[")); addchild($$, $3); addchild($$, create_leaf("]")); }
  | LEFT_PAREN parameter_type_list_opt RIGHT_PAREN  { $$= create_root(create_leaf("("),"direct_abstract_declarator"); addchild($$, $2); addchild($$, create_leaf(")")); }
  | direct_abstract_declarator LEFT_PAREN parameter_type_list_opt RIGHT_PAREN   { $$= create_root($1,"direct_abstract_declarator"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); }
  ;

parameter_type_list_opt:
    parameter_type_list { $$= $1; }
  | /* empty */  {$$=create_leaf("NULL");}
  ;

type_name:
    specifier_qualifier_list abstract_declarator_opt    { $$= create_root($1,"type_name"); addchild($$, $2); }
  ;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt  { $$= create_root($1,"specifier_qualifier_list"); addchild($$, $2); }
  | type_qualifier specifier_qualifier_list_opt { $$= create_root($1,"specifier_qualifier_list"); addchild($$, $2); }
  ;

specifier_qualifier_list_opt:
    specifier_qualifier_list   { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

initializer:
    assignment_expression   { $$= create_root($1,"initializer"); }
  | LEFT_BRACE initializer_list RIGHT_BRACE  { $$= create_root(create_leaf("{"),"initializer"); addchild($$, $2); addchild($$, create_leaf("}")); }
  | LEFT_BRACE initializer_list COMMA RIGHT_BRACE   { $$= create_root(create_leaf("{"),"initializer"); addchild($$, $2); addchild($$, create_leaf(",")); addchild($$, create_leaf("}")); }
  ;

initializer_list:
    designation_opt initializer { $$= create_root($1,"initializer_list"); addchild($$, $2); }
  | initializer_list COMMA designation_opt initializer  { $$= create_root($1,"initializer_list"); addchild($$, create_leaf(",")); addchild($$, $3); }
  ;

designation_opt:
    designation { $$= $1; }
  | /* empty */ {$$=create_leaf("NULL");}
  ;

designation:
    designator_list ASSIGN  { $$= create_root($1,"designation"); addchild($$, create_leaf("=")); }
  ;

designator_list:
    designator  { $$= create_root($1,"designator_list"); }
  | designator_list designator  { $$= create_root($1,"designator_list"); addchild($$, $2); }
  ;

designator:
    LEFT_BRACKET constant_expression RIGHT_BRACKET  { $$= create_root(create_leaf("["),"designator"); addchild($$, $2); addchild($$, create_leaf("]")); }
  | DOT ID  { $$= create_root(create_leaf("."),"designator"); addchild($$, create_leaf($2)); }
  ;

statement:
    labeled_statement   { $$= create_root($1,"statement"); }
  | compound_statement  { $$= create_root($1,"statement"); }
  | expression_statement    { $$= create_root($1,"statement"); }
  | selection_statement { $$= create_root($1,"statement"); }
  | iteration_statement { $$= create_root($1,"statement"); }
  | jump_statement  { $$= create_root($1,"statement"); }
  ;

labeled_statement:
    ID COLON statement  { $$= create_root(create_leaf($1),"labeled_statement"); addchild($$, create_leaf(":")); addchild($$, $3); }
  | CASE constant_expression COLON statement    { $$= create_root(create_leaf("case"),"labeled_statement"); addchild($$, $2); addchild($$, create_leaf(":")); addchild($$, $4); }
  | DEFAULT COLON statement { $$= create_root(create_leaf("default"),"labeled_statement"); addchild($$, create_leaf(":")); addchild($$, $3); }
  ;

compound_statement:
    LEFT_BRACE block_item_list_opt RIGHT_BRACE  { $$= create_root(create_leaf("{"),"compound_statement"); addchild($$, $2); addchild($$, create_leaf("}")); }
  ;

block_item_list_opt:
    block_item_list     { $$= $1; }
  | /* empty */   {$$=create_leaf("NULL");}
  ;

block_item_list:
    block_item      { $$= create_root($1,"block_item_list"); }
  | block_item_list block_item  { $$= create_root($1,"block_item_list"); addchild($$, $2); }
  ;

block_item:
    declaration    { $$= create_root($1,"block_item"); }
  | statement   { $$= create_root($1,"block_item"); }
  ;

expression_statement:
    expression_opt SEMICOLON    { $$= create_root($1,"expression_statement"); addchild($$, create_leaf(";")); }
  ;

expression_opt:
    expression  { $$= $1; }
  | /* empty */   {$$=create_leaf("NULL");}
  ;

selection_statement:
    IF LEFT_PAREN expression RIGHT_PAREN statement %prec LOWER_THAN_ELSE  { $$= create_root(create_leaf("if"),"selection_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); addchild($$, $5); }
  | IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement   { $$= create_root(create_leaf("if"),"selection_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); addchild($$, $5); addchild($$, create_leaf("else")); addchild($$, $7); }
  | SWITCH LEFT_PAREN expression RIGHT_PAREN statement  { $$= create_root(create_leaf("switch"),"selection_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); addchild($$, $5); }
  ;

iteration_statement:
    WHILE LEFT_PAREN expression RIGHT_PAREN statement   { $$= create_root(create_leaf("while"),"iteration_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(")")); addchild($$, $5); }
  | DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON  { $$= create_root(create_leaf("do"),"iteration_statement"); addchild($$, $2); addchild($$, create_leaf("while")); addchild($$, create_leaf("(")); addchild($$, $5); addchild($$, create_leaf(")")); addchild($$, create_leaf(";")); }
  | FOR LEFT_PAREN expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RIGHT_PAREN statement   { $$= create_root(create_leaf("for"),"iteration_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$, create_leaf(";")); addchild($$, $5); addchild($$, create_leaf(";")); addchild($$, $7); addchild($$, create_leaf(")")); addchild($$, $9); }
  | FOR LEFT_PAREN declaration expression_opt SEMICOLON expression_opt RIGHT_PAREN statement    { $$= create_root(create_leaf("for"),"iteration_statement"); addchild($$, create_leaf("(")); addchild($$, $3); addchild($$,$4) ; addchild($$, create_leaf(";")); addchild($$, $6); addchild($$, create_leaf(")")); addchild($$, $8); }
  ;

jump_statement:
    GOTO ID SEMICOLON   { $$= create_root(create_leaf("goto"),"jump_statement"); addchild($$, create_leaf($2)); addchild($$, create_leaf(";")); }
  | CONTINUE SEMICOLON  { $$= create_root(create_leaf("continue"),"jump_statement"); addchild($$, create_leaf(";")); }
  | BREAK SEMICOLON     { $$= create_root(create_leaf("break"),"jump_statement"); addchild($$, create_leaf(";")); }
  | RETURN expression_opt SEMICOLON { $$= create_root(create_leaf("return"),"jump_statement"); addchild($$, $2); addchild($$, create_leaf(";")); }
  ;

starting_point:
    translation_unit    { $$= $1;print_tree($$,0); }
  ;

translation_unit:
    external_declaration    { $$= create_root($1,"translation_unit"); } 
  | translation_unit external_declaration   { $$= create_root($1,"translation_unit"); addchild($$, $2); }
  ;

external_declaration:
    function_definition { $$= create_root($1,"external_declaration"); }
  | declaration     { $$= create_root($1,"external_declaration"); }
  ;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement   { $$= create_root($1,"function_definition"); addchild($$, $2); addchild($$, $3); addchild($$, $4); }
  ;

declaration_list_opt:
    declaration_list    { $$= $1; }
  | /* empty */   {$$=create_leaf("NULL");}
  ;

declaration_list:
    declaration    { $$= create_root($1,"declaration_list"); }
  | declaration_list declaration    { $$= create_root($1,"declaration_list"); addchild($$, $2); }
  ;

%%