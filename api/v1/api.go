package api

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"github.com/spohnan/ws-test-01/meta"
	"log"
	"net/http"
	"fmt"
)

func InitApi(r *mux.Router) {
	log.Println("Initializing API ...")

	r.HandleFunc("/", versionHandler)
	r.HandleFunc("/health", healthHandler)
	r.HandleFunc("/version", versionHandler)

	//sr := r.PathPrefix("/api/v1").Subrouter()
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	//TODO: Actually check the health of the app
	fmt.Fprintln(w, "OK")
}

func versionHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json, _ := json.Marshal(meta.App)
	w.Write(json)
}
