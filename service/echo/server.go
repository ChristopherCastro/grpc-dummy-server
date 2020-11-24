package echo

import (
	"context"

	echopb "github.com/protos/go/api/grpc/echo"
)

type server struct {
}


func NewEchoService() echopb.EchoServiceServer {
	return &server{}
}

func (s *server) Echo(ctx context.Context, request *echopb.EchoRequest) (*echopb.EchoResponse, error) {
	return &echopb.EchoResponse{
		Body: request.Body,
	}, nil
}