package main

import (
	"database/sql"
	_ "github.com/lib/pq"
	"log"
	"net/http"
	"os"
)

var requiredEnvs = []string{"APP_API_KEY", "APP_DB_CONNECTION"}

func main() {
	apiKey := getEnv("APP_API_KEY", "")
	dbConnectionString := getEnv("APP_DB_CONNECTION", "")
	port := getEnv("APP_PORT", "8080")

	db, err := sql.Open("postgres", dbConnectionString)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	http.HandleFunc("/openapi", GetOpenAPISchemaHandler)
	http.HandleFunc("/query", QueryHandler(db, apiKey))

	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func getEnv(key, fallback string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		for _, requiredEnv := range requiredEnvs {
			if requiredEnv == key {
				log.Fatalf("%s environment variable is not set", key)
			}
		}
		value = fallback
	}
	return value
}
