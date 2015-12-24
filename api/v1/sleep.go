package api

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"time"
	"strconv"
)

func InitSleep(r *mux.Router) {
	sr := r.PathPrefix("/sleep/{millis}").Subrouter()
	sr.HandleFunc("/", getSleep).Methods("GET")
}

func getSleep(w http.ResponseWriter, r *http.Request) {
	millis := mux.Vars(r)["millis"]
	m, err := strconv.Atoi(millis)
	if err != nil {
		m = 0
	}
	time.Sleep(time.Millisecond * time.Duration(m))
	out := fmt.Sprintf("<html><head/><body><pre>slept (millis):\t%s\n</pre></html>", millis)
	w.Write([]byte(out))
}
