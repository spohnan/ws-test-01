package api

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"time"
	"strconv"
)

func InitSleep(r *mux.Router) {
	sr := r.PathPrefix("/sleep/{seconds}").Subrouter()
	sr.HandleFunc("/", getSleep).Methods("GET")
}

func getSleep(w http.ResponseWriter, r *http.Request) {
	seconds := mux.Vars(r)["seconds"]
	ns, err := strconv.Atoi(seconds)
	if err != nil {
		ns = 0
	}
	time.Sleep(time.Second * time.Duration(ns))
	out := fmt.Sprintf("<html><head/><body><pre>slept (seconds):\t%s\n</pre></html>", seconds)
	w.Write([]byte(out))
}

