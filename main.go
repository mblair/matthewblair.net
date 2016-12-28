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
	tmpl *template.Template
	site []byte
)

func markDowner(input []byte) template.HTML {
	s := blackfriday.MarkdownCommon(input)
	return template.HTML(s)
}

func init() {
	tmpl = template.Must(template.New("template.html").Funcs(template.FuncMap{"markDown": markDowner}).ParseFiles("template.html"))
	site, _ = ioutil.ReadFile("home.md")
}

func secureHandler(w http.ResponseWriter, req *http.Request) {
	log.Println("got an HTTPS request with major version:", req.ProtoMajor)

	var p struct {
		Body []byte
	}

	p.Body = site

	err := tmpl.ExecuteTemplate(w, "template.html", p)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func insecureHandler(w http.ResponseWriter, req *http.Request) {
	http.Redirect(w, req,
		"https://"+req.Host+req.URL.String(),
		http.StatusMovedPermanently,
	)
}

func main() {
	go func() {
		log.Println("Listening on 80; Go to http://matthewblair.net")
		err := http.ListenAndServe(":http", http.HandlerFunc(insecureHandler))
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
