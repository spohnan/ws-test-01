package api

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"net/http"
	"os"
)

func InitEnv(r *mux.Router) {
	sr := r.PathPrefix("/env/{key}").Subrouter()
	sr.HandleFunc("/", getEnv).Methods("GET")
}

type EnvInfo struct {
	Name string
	Value string
}

func getEnv(w http.ResponseWriter, r *http.Request) {
	envInfo := &EnvInfo{}
	envKey := mux.Vars(r)["key"]
	envInfo.Name = envKey
	envInfo.Value = os.Getenv(envKey)

	json, _ := json.Marshal(envInfo)
	w.Header().Set("Content-Type", "application/json")
	w.Write(json)
}
