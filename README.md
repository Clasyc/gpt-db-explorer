# Go SQL Query Executor

## Description

This project is a Go application that uses PostgreSQL for data storage. Application has single endpoint that takes
input as RAW SQL and returns the result of the query. The main purpose of this project is to demonstrate how we can 
use custom GPT app to interact with the database.

## How it works:

1. GPT generates a SQL query based on the user input.
2. The Go application takes the generated SQL query and executes it against the database.
3. The result of the query is returned to GPT.
4. GPT formats the result and returns it to the user.

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Ngrok](https://ngrok.com/download) (optional)

## Getting Started

1. Clone the repository:
    ```
    git clone https://github.com/username/project.git
    cd project
    ```
   
2. Create a `.env` file in the root of the project:
    ```
    mv .env.example .env
    ```

3. Run the application:
    ```
    make run
    ```

4. Expose the application to the internet using Ngrok (optional):
    ```
    ngrok http $APP_CONTAINER_PORT
    ```

## Database Schema

![Database Schema](scheme.png)

The database schema is documented in detail in `doc.md`.
This should be used as a context for GPT model so that it can generate SQL queries that are compatible with the database.

### Sample Data

Sample database schema and data is taken from 
[this repository](https://github.com/morenoh149/postgresDBSamples/tree/master/dellstore2-normal-1.0)

## OpenAPI Specification

The OpenAPI specification for the application is documented in `openapi.yaml`.
This should be used as a reference for the API endpoint that GPT should interact with.

> Note: The OpenAPI specification contains hardcoded URL, please replace it with your Ngrok URL. Before uploading
> it to the GPT model.
