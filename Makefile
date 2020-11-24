PROTOC=protoc

usage:
	@echo "make [proto|build|run|test]"
	@echo "   - proto : compile interface spec"
	@echo "   - build : compile the server"
	@echo "   - run   : start the server"

proto p:
	rm -rf protos/*_pb.go
	GOBIN=$(CURDIR)/bin go install github.com/uber/prototool/cmd/prototool
	PATH=$(CURDIR)/bin bin/prototool generate
	@ls -al ./proto

build b:
	go build -o server main.go

rebuild rb:
	make proto
	make build

run r:
	./server

