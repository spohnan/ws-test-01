package api

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
)

func InitHost(r *mux.Router) {
	sr := r.PathPrefix("/host").Subrouter()
	sr.HandleFunc("/", getHost).Methods("GET")
}

type HostInfo struct {
	HostName string
}

func getHost(w http.ResponseWriter, r *http.Request) {
	host, err := os.Hostname()
	hostInfo := &HostInfo{}
	if err == nil {
		hostInfo.HostName = host
	} else {
		log.Printf("Error: Problem while attempting to get hostname - %s", err)
	}

	json, _ := json.Marshal(hostInfo)
	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}
