usage:
	@echo "make [proto|build|run|test]"
	@echo "   - proto : compile interface spec"
	@echo "   - build : compile the server"
	@echo "   - run   : start the server"

proto p:
	GOBIN=$(CURDIR)/bin go install google.golang.org/protobuf/cmd/protoc-gen-go
	GOBIN=$(CURDIR)/bin go install github.com/uber/prototool/cmd/prototool
	PATH=$(CURDIR)/bin bin/prototool generate --debug
	@ls -al ./proto

bin/prototool:
	GOBIN=$(CURDIR)/bin go install github.com/uber/prototool/cmd/prototool
#	GOBIN=$(CURDIR)/bin go install github.com/bufbuild/buf/cmd/buf
bin/protoc-gen-go:
	GOBIN=$(CURDIR)/bin go install github.com/golang/protobuf/protoc-gen-go

protos-generate: bin/protoc-gen-go bin/prototool
	rm -rf protos/*
	PATH=$(CURDIR)/bin bin/prototool generate
.PHONY: protos-generate

build b:
	go build -o server main.go

rebuild rb:
	make proto
	make build

run r:
	./server

