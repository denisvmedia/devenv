package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	h, _ := os.Hostname()
	fmt.Fprintf(w, "Howdy, stranger. You came from %s.", h)

	requestDump, err := httputil.DumpRequest(r, true)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(requestDump))
}

func main() {
	http.HandleFunc("/", handler)
	bind := os.Getenv("BIND_ADDRESS")
	if bind == "" {
		bind = ":80"
	}
	log.Printf("Listening on %s", bind)
	log.Fatal(http.ListenAndServe(bind, nil))
}
