package main

import (
	"database/sql"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

func GetOpenAPISchemaHandler(w http.ResponseWriter, r *http.Request) {
	schema, err := getOpenAPISchema()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/yaml")
	w.Write([]byte(schema))
}

func QueryHandler(db *sql.DB, apiKey string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("X-API-Key") != apiKey {
			http.Error(w, "Unauthorized", http.StatusUnauthorized)
			return
		}

		if r.Method != "POST" {
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
			return
		}

		var req struct {
			Query string `json:"query"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		rows, err := db.Query(req.Query)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		log.Println("Executing query:", req.Query) // Log the query

		var results []map[string]interface{}
		cols, _ := rows.Columns()
		for rows.Next() {
			columns := make([]interface{}, len(cols))
			columnPointers := make([]interface{}, len(cols))
			for i := range columns {
				columnPointers[i] = &columns[i]
			}

			if err := rows.Scan(columnPointers...); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}

			result := make(map[string]interface{})
			for i, colName := range cols {
				val := columnPointers[i].(*interface{})
				result[colName] = *val
			}
			results = append(results, result)
		}

		log.Println("Query results:", results) // Log the results

		json.NewEncoder(w).Encode(results)
	}
}

func getOpenAPISchema() (string, error) {
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	fileBytes, err := ioutil.ReadFile(filepath.Join(dir, "openAPI.yml"))
	if err != nil {
		return "", err
	}
	return string(fileBytes), nil
}
