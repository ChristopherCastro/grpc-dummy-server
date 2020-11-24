package server

import (
	"log"
	"net"

	"google.golang.org/grpc"
)

func main() {
	ln, err:= net.Listen("tcp", ":8080")
	if err != nil{
		log.Fatalf("%s\n", err)
	}

	s:= grpc.NewServer()
	pb.RegisterSensorServer(s, &server{})

	//Serve our new clients
	s.Serve(ln)
}




