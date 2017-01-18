%{
package main

import (
  "strconv"
)
%}

%union{
  token Token
  expr Expr
  members []Expr
  elements []Expr
  object map[string]Expr
}

%type<object> document
%type<object> object
%type<expr> value
%type<expr> array
%type<expr> literal
%type<expr> pair
%type<members> members
%type<elements> elements
%token<token> NUMBER STRING
%token TRUE FALSE NULL
%token LBR RBR LBK RBK COMMA COLON

%%

document:
        object
        {
          $$ = $1
          yylex.(*Lexer).result = $$
        }

object:
      LBR RBR
      {
        $$ = map[string]Expr{}
      }
      | LBR members RBR
      {
        $$ = map[string]Expr{}
        for _, p := range $2 {
          $$[p.(Pair).key] = p.(Pair).value
        }
      }

members:
       pair
       {
        $$ = []Expr{$1}
       }
       | pair COMMA members
       {
       $$ = append([]Expr{$1}, $3...)
       }

pair:
    STRING COLON value
    {
      $$ = Pair{key: $1.literal, value: $3}
    }

value:
     object
     {
     $$ = $1
     }
     | array
     {
     $$ = $1
     }
     | literal
     {
     $$ = $1
     }

literal:
      STRING
      {
       $$ = $1.literal
      }
      | NUMBER
      {
       if i, err := strconv.Atoi($1.literal); err == nil {
        $$ = i
       }
      }
      | TRUE
      {
       $$ = true
      }
      | FALSE
      {
       $$ = false
      }
      | NULL
      {
       $$ = nil
      }

array:
     LBK RBK
     {
      $$ = []Expr{}
     }
     | LBK elements RBK
     {
      $$ = $2
     }

elements:
        value
        {
          $$ = []Expr{$1}
        }
        | value COMMA elements
        {
          $$ = append([]Expr{$1}, $3...)
        }

%%
