package main

import (
	"fmt"
	"os"
)

func main() {
	lex := NewLexer(os.Stdin)
	yyParse(lex)
	fmt.Printf("%#v\n", lex.result)
}
