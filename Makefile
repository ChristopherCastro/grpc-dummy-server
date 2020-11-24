usage:
	@echo "make [proto|build|run|test]"
	@echo "   - proto : compile interface spec"
	@echo "   - build : compile the server"
	@echo "   - run   : start the server"

proto p:
	GOBIN=$(CURDIR)/bin go install github.com/golang/protobuf/protoc-gen-go
	GOBIN=$(CURDIR)/bin go install github.com/uber/prototool/cmd/prototool
	PATH=$(CURDIR)/bin bin/prototool generate --debug
	@find ./protos -print

build b:
	go build -o bin/server main.go

rebuild rb:
	make proto
	make build

run r:
	./server

