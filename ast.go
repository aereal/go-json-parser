package main

type Expr interface{}

type Token struct {
	token   int
	literal string
}
