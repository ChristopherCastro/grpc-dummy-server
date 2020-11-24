package stream

import (
	"time"

	streampb "github.com/protos/go/api/grpc/stream"
)

type server struct {
}

func NewStreamService() streampb.StreamServiceServer {
	return &server{}
}

func (s *server) Ping(request *streampb.PingRequest, pingServer streampb.StreamService_PingServer) error {
	msg := request.Body
	ctx := pingServer.Context()
	ticker := time.NewTicker(time.Second)

	for {
		select {
			case <-ctx.Done():
				return nil
			case <-ticker.C:
				err := pingServer.Send(&streampb.PingResponse{
					Body: msg,
				})

				if err != nil {
					return err
				}
		}
	}
}

