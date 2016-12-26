package main

import (
	"crypto/tls"
	"log"
	"net/http"

	"golang.org/x/crypto/acme/autocert"
)

func secureHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")

	log.Println("got an HTTPS request with major version:", req.ProtoMajor)
	w.Write([]byte("Hello world!"))
}

func main() {
	go func() {
		log.Println("Listening on 80; Go to http://matthewblair.net, and you should be redirected...")
		err := http.ListenAndServe(":http", http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
			http.Redirect(w, req,
				"https://"+req.Host+req.URL.String(),
				http.StatusMovedPermanently,
			)
		}))

		if err != nil {
			log.Fatal(err)
		}
	}()

	http.HandleFunc("/", secureHandler)

	m := autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		Email:      "me@matthewblair.net",
		HostPolicy: autocert.HostWhitelist("matthewblair.net"),
	}

	s := http.Server{
		Addr:      ":https",
		TLSConfig: &tls.Config{GetCertificate: m.GetCertificate},
	}

	log.Println("Listening on 443; Go to https://matthewblair.net")
	err := s.ListenAndServeTLS("", "")
	if err != nil {
		log.Fatal(err)
	}
}
