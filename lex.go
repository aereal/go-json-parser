package main

import (
	"fmt"
	"io"
	"strconv"
	"text/scanner"
)

var symbolTables = map[string]int{
	"{":     LBR,
	"}":     RBR,
	"[":     LBK,
	"]":     RBK,
	"true":  TRUE,
	"false": FALSE,
	"null":  NULL,
	",":     COMMA,
	":":     COLON,
}

type Lexer struct {
	scanner.Scanner
	result Expr
}

func NewLexer(in io.Reader) *Lexer {
	l := new(Lexer)
	l.Init(in)
	l.Mode &^= scanner.ScanInts | scanner.ScanFloats | scanner.ScanChars | scanner.ScanRawStrings | scanner.ScanComments | scanner.SkipComments
	return l
}

func (l *Lexer) Lex(lval *yySymType) int {
	token := int(l.Scan())
	s := l.TokenText()
	if token == scanner.String {
		token = STRING
		s = s[1 : len(s)-1] // trim double quotes
	}
	if token == scanner.Int {
		token = NUMBER
	}
	if _, err := strconv.Atoi(s); err == nil {
		token = NUMBER
	}
	if _, ok := symbolTables[s]; ok {
		token = symbolTables[s]
	}
	fmt.Printf("token:%v literal:%v string?:%v\n", token, s, token == scanner.String)
	lval.token = Token{token: token, literal: s}
	return token
}

func (l *Lexer) Error(e string) {
	panic(fmt.Errorf("%v: line:%d column:%d", e, l.Line, l.Column))
}
