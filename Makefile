SHELL := /bin/bash
.PHONY: logs

include .env
export

file ?= store.sql

run: destroy build import create-user example

up:
	docker-compose up -d

stop:
	docker-compose stop

build:
	docker-compose up -d --build

destroy:
	docker-compose down -v

create-user:
	. .env && ./create-user.sh

wait_for_postgres:
	@echo "Waiting for PostgreSQL to start..."
	@until docker exec -i db bash -c "PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(POSTGRES_USER) -p 5432 -c '\q'" 2>/dev/null; do \
	    sleep 1; \
	done
	@echo "PostgreSQL started."

import: wait_for_postgres
	PGPASSWORD=$(POSTGRES_PASSWORD) docker exec -i db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < ./$(file)

ngrok:
	ngrok http $(APP_CONTAINER_PORT)

db:
	docker exec -it db psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

logs:
	docker logs -f app

api:
	curl -X POST -H "Content-Type: application/json" -H "X-API-Key: $(APP_API_KEY)" \
	--data '{"query":"$(query)"}' \
	http://localhost:$(APP_PORT)/query

example:
	@echo "Running example request with 'SELECT COUNT(*) FROM orders' query..."
	@make -s api query='SELECT COUNT(*) FROM orders'