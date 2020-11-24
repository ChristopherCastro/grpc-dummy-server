package server

import (
	"log"
	"net"

	streampb "github.com/protos/go/api/grpc/stream"
	"github.com/service/stream"
	"google.golang.org/grpc"
)

func main() {
	ln, err:= net.Listen("tcp", ":7000")
	if err != nil{
		log.Fatalf("%s\n", err)
	}

	s:= grpc.NewServer()
	streampb.RegisterStreamServiceServer(s, stream.NewStreamService())
	streampb.RegisterStreamServiceServer(s, stream.NewStreamService())

	if err := s.Serve(ln); err != nil {
		log.Fatalf("%s\n", err)
	}
}




