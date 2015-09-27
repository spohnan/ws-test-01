package server

import (
	"github.com/braintree/manners"
	"github.com/gorilla/mux"
	"github.com/spohnan/ws-test-01/api/v1"
	"github.com/spohnan/ws-test-01/meta"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"
)

// Server is a structure that encapsulates all components
type Server struct {
	Server *manners.GracefulServer
	Router *mux.Router
}

var srv *Server

// Start initializes and starts the web server
func Start() {

	srv = &Server{}
	srv.Router = mux.NewRouter()

	srv.Server = manners.NewWithServer(&http.Server{
		Addr:           ":8080",
		Handler:        srv.Router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	})

	log.Printf("Starting Server v%s ...", meta.App.Version)
	api.InitAPI(srv.Router)
	startShutdownListener()
	srv.Server.ListenAndServe()
}

func startShutdownListener() {
	go func() {
		log.Println("Starting shutdown listener")
		sigchan := make(chan os.Signal, 1)
		signal.Notify(sigchan, os.Interrupt, os.Kill)
		<-sigchan
		log.Println("Shutting down ...")
		srv.Server.Close()
		log.Println("Stopped")
	}()
}
