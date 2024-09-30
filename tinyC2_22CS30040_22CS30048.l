%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyC2_22CS30040_22CS30048.tab.h"
%}

%x MULTI_LINE_COMMENT_BODY
%x SINGLE_LINE_COMMENT_BODY

/* Regular Expressions */
Alphabet [a-zA-Z]
newline \n
space [ ]
spaces {space}+
digit [0-9]
sign [+-]


identifier {identifier_nondigit}({identifier_nondigit}|{digit})*
identifier_nondigit [_]|{Alphabet}


integer_constant {digit}+
floating_constant ({fractional_constant}{exponent_part}?)|({digit_sequence}{exponent_part})
fractional_constant ({digit_sequence}?\.{digit_sequence})|({digit_sequence}\.)
exponent_part ([eE]{sign}?{digit_sequence})
digit_sequence {digit}+
escape_sequence \\(["']|[\\abfnrtv?])
c_char [^'\\\n]|{escape_sequence}
character_constant [']{c_char}+[']
s_char [^"\\\n]|{escape_sequence}
s_char_sequence {s_char}+
string_literal ["]{s_char_sequence}?["]
constant {floating_constant}|{character_constant}|{integer_constant}

%%

"sizeof"                  { yylval.id = strdup(yytext); return SIZEOF; }
"void"                    { yylval.id = strdup(yytext); return VOID; }
"char"                    { yylval.id = strdup(yytext);return CHAR; }
"short"                   { yylval.id = strdup(yytext);return SHORT; }
"int"                     { yylval.id = strdup(yytext);return INT; }
"long"                    { yylval.id = strdup(yytext);return LONG; }
"float"                   { yylval.id = strdup(yytext);return FLOAT; }
"double"                  { yylval.id = strdup(yytext);return DOUBLE; }
"signed"                  { yylval.id = strdup(yytext);return SIGNED; }
"unsigned"                { yylval.id = strdup(yytext);return UNSIGNED; }
"_Bool"                   { yylval.id = strdup(yytext);return BOOL; }
"_Complex"                 { yylval.id = strdup(yytext);return COMPLEX; }
"_Imaginary"               { yylval.id = strdup(yytext);return IMAGINARY; }


"extern"                  { yylval.id = strdup(yytext);return EXTERN; }
"static"                  { yylval.id = strdup(yytext);return STATIC; }
"auto"                    { yylval.id = strdup(yytext);return AUTO; }
"register"                { yylval.id = strdup(yytext);return REGISTER; }


"const"                  { yylval.id = strdup(yytext);return CONST; }
"restrict"               { yylval.id = strdup(yytext);return RESTRICT; }
"volatile"               { yylval.id = strdup(yytext);return VOLATILE; }


"inline"                 { yylval.id = strdup(yytext);return INLINE; }


"if"                      {return IF; }
"else"                    {return ELSE; }
"switch"                  { return SWITCH; }
"case"                    { return CASE; }
"default"                 { return DEFAULT; }


"while"                   { return WHILE; }
"for"                     { return FOR; }
"do"                      { return DO; }


"goto"                    { return GOTO; }
"continue"                { return CONTINUE; }
"break"                   { return BREAK; }
"return"                  { return RETURN; }

"->"            { return ARROW; }
"++"            { return INCREMENT; }
"--"            { return DECREMENT; }
"&&"            { return LOGICAL_AND; }
">="            { return GREATER_EQUAL; }
"<="            { return LESS_EQUAL; }
"<<"            { return LEFT_SHIFT; }
">>"            { return RIGHT_SHIFT; }
"=="            { return EQUAL; }
"!="            { return NOT_EQUAL; }
"||"            { return LOGICAL_OR; }
"*="            { return MULTIPLY_ASSIGN_1; }
"..."           { return ELLIPSIS; }
"/="            { return DIVIDE_ASSIGN; }
"%="            { return MODULO_ASSIGN; }
"+="            { return PLUS_ASSIGN; }
"-="            { return MINUS_ASSIGN; }
"<<="           { return LEFT_SHIFT_ASSIGN; }
">>="           { return RIGHT_SHIFT_ASSIGN; }
"&="            { return AND_ASSIGN; }
"^="            { return XOR_ASSIGN; }
"|="            { return OR_ASSIGN; }
"("             { return LEFT_PAREN; }
")"             { return RIGHT_PAREN; }
"{"             { return LEFT_BRACE; }
"}"             { return RIGHT_BRACE; }
"["             { return LEFT_BRACKET; }
"]"             { return RIGHT_BRACKET; }
","             { return COMMA; }
"#"             { return HASH; }
"<"             { return LESS_THAN; }
">"             { return GREATER_THAN; }
"="             { return ASSIGN; }
"&"             { return AMPERSAND; }
"*"             { return ASTERISK; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"~"             { return TILDE; }
"!"             { return EXCLAMATION; }
"/"             { return FORWARD_SLASH; }
"%"             { return PERCENT; }
"."             { return DOT; }
"^"             { return CARET; }
"|"             { return VERTICAL_BAR; }
"?"             { return QUESTION_MARK; }
":"             { return COLON; }
";"             { return SEMICOLON; }

{identifier}              { yylval.id = strdup(yytext);return ID; }
{string_literal}          { yylval.id = strdup(yytext);return STRING; }
{constant}                { yylval.id = strdup(yytext);return CONSTANT; }


"/*"                                { BEGIN(MULTI_LINE_COMMENT_BODY); }
<MULTI_LINE_COMMENT_BODY>"*/"       { BEGIN(INITIAL);}
<MULTI_LINE_COMMENT_BODY>.          { }
<MULTI_LINE_COMMENT_BODY>"\n"       { /* printf("\n************** Line %d **************\n\n", yylineno); */ }

"//"                                { BEGIN(SINGLE_LINE_COMMENT_BODY); }
<SINGLE_LINE_COMMENT_BODY>"\n"      { BEGIN(INITIAL); } 
<SINGLE_LINE_COMMENT_BODY>.         { }





{spaces}                  { /* Ignore spaces */ }
{newline}                 { /* Ignore newlines */ }

.                         {}

%%

int yywrap() {
    return 1;
}
 

 