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

type Server struct {
	Server *manners.GracefulServer
	Router *mux.Router
}

var Srv *Server

func Start() {

	Srv = &Server{}
	Srv.Router = mux.NewRouter()

	Srv.Server = manners.NewWithServer(&http.Server{
		Addr:           ":8080",
		Handler:        Srv.Router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	})

	log.Printf("Starting Server v%s ...", meta.App.Version)
	api.InitApi(Srv.Router)
	startShutdownListener()
	Srv.Server.ListenAndServe()
}

func startShutdownListener() {
	go func() {
		log.Println("Starting shutdown listener")
		sigchan := make(chan os.Signal, 1)
		signal.Notify(sigchan, os.Interrupt, os.Kill)
		<-sigchan
		log.Println("Shutting down ...")
		Srv.Server.Close()
		log.Println("Stopped")
	}()
}
