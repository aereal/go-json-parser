build: parser.go
	go build ./...

parser.go: parser.go.y
	go tool yacc -o parser.go parser.go.y
