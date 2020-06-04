package main

import (
	"crypto/tls"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/russross/blackfriday"
	"golang.org/x/crypto/acme/autocert"
)

var (
	tmpl    *template.Template
	content []byte
	css     []byte
)

func markDowner(input []byte) template.HTML {
	s := blackfriday.Run(input)
	return template.HTML(s)
}

func init() {
	tmpl = template.Must(template.New("template.html").Funcs(template.FuncMap{"markDown": markDowner}).ParseFiles("template.html"))
	content, _ = ioutil.ReadFile("home.md")
	css, _ = ioutil.ReadFile("style.css")
}

func secureHandler(w http.ResponseWriter, req *http.Request) {
	if req.URL.Path == "/style.css" {
		w.Header().Set("Content-Type", "text/css")
		w.Write(css)
		return
	}

	var p struct {
		Body []byte
	}

	p.Body = content

	err := tmpl.ExecuteTemplate(w, "template.html", p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/", secureHandler)

	m := autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		Email:      "me@matthewblair.net",
		Cache:      autocert.DirCache("/var/cache/acme/"),
		HostPolicy: autocert.HostWhitelist("matthewblair.net"),
	}

	insecure := &http.Server{
		Handler: m.HTTPHandler(nil),
		Addr:    ":80",
	}

	go insecure.ListenAndServe()

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
