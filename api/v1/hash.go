package api

import (
	"crypto/sha512"
	"github.com/gorilla/mux"
	"math/rand"
	"net/http"
	"fmt"
)

func InitHash(r *mux.Router) {
	sr := r.PathPrefix("/hash").Subrouter()
	sr.HandleFunc("/", getHash).Methods("GET")
}

func getHash(w http.ResponseWriter, r *http.Request) {
	input := randSeq(100)
	sha_512 := sha512.New()
	sha_512.Write([]byte(input))
	out := fmt.Sprintf("<html><head/><body><pre>input:\t%s\n", input)
	out += fmt.Sprintf("sha512:\t%x\n</pre></body></html>", sha_512.Sum(nil))
	w.Write([]byte(out))
}

var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func randSeq(n int) string {
	b := make([]rune, n)
	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)
}
