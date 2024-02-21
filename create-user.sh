#!/bin/bash

. .env

PG_SUPERUSER=$POSTGRES_USER
PG_SUPERUSER_PASSWORD=$POSTGRES_PASSWORD
DB_PORT=5432
READONLY_USERNAME="readonlyuser"
READONLY_PASSWORD="password"

# Function to wait for the PostgreSQL server to start
wait_for_postgres() {
    echo "Waiting for PostgreSQL to start..."
    local max_attempts=30  # Maximum number of attempts
    local attempt=1        # Current attempt
    local sleep_seconds=1  # Seconds to sleep between attempts

    until docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -c '\q'" 2>/dev/null; do
        sleep $sleep_seconds
        echo "Attempt $attempt of $max_attempts: Waiting for PostgreSQL..."
        if [ $attempt -eq $max_attempts ]; then
            echo "PostgreSQL did not start within the expected time frame."
            exit 1
        fi
        attempt=$((attempt+1))
    done
    echo "PostgreSQL started."
}

# Function to execute a command as the PostgreSQL superuser
execute_as_pg_superuser() {
    docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -At -c \"$1\""
}

# Function to create a readonly user
create_readonly_user() {
    # Execute the command and directly capture the output (number of rows matching the role)
    USER_EXISTS=$(execute_as_pg_superuser "SELECT COUNT(*) FROM pg_roles WHERE rolname='$READONLY_USERNAME';")
    USER_EXISTS=$(echo $USER_EXISTS | xargs) # Trim any whitespace

    if [ "$USER_EXISTS" -eq "0" ]; then
        echo "Creating readonly user: $READONLY_USERNAME"
        execute_as_pg_superuser "CREATE ROLE $READONLY_USERNAME WITH LOGIN PASSWORD '$READONLY_PASSWORD';"
    else
        echo "Readonly user $READONLY_USERNAME already exists, skipping creation."
    fi
}

# Function to grant permissions to readonly user for each database
grant_permissions() {
    # Get list of all non-template databases
    DATABASES=$(execute_as_pg_superuser "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';")

    for DB in $DATABASES; do
        # Get list of all schemas in the current database
        SCHEMAS=$(docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -d $DB -At -c \"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('pg_catalog', 'information_schema');\"")

        for SCHEMA in $SCHEMAS; do
            echo "Granting permissions on schema: $SCHEMA in database: $DB"
            # Grant USAGE on the schema
            docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -d $DB -c \"GRANT USAGE ON SCHEMA $SCHEMA TO $READONLY_USERNAME;\""

            # Grant SELECT on all tables in the schema
            docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -d $DB -c \"GRANT SELECT ON ALL TABLES IN SCHEMA $SCHEMA TO $READONLY_USERNAME;\""

            # Ensure future tables in this schema grant SELECT to the readonly user
            docker exec -i db bash -c "PGPASSWORD=$PG_SUPERUSER_PASSWORD psql -U $PG_SUPERUSER -p $DB_PORT -d $DB -c \"ALTER DEFAULT PRIVILEGES IN SCHEMA $SCHEMA FOR ROLE $PG_SUPERUSER GRANT SELECT ON TABLES TO $READONLY_USERNAME;\""
        done
    done

    echo "Read-only user setup complete."
}

wait_for_postgres
create_readonly_user
grant_permissions

echo "Read-only user setup complete."