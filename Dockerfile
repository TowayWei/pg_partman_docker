# Base image: postgres:17.0-bookworm
FROM postgres:17.0-bookworm

# Update and install pg_partman and related dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-17-partman \
        python3 \
        python3-psycopg2 \
    && rm -rf /var/lib/apt/lists/*

# Optional: Add initialization script for pg_partman
# RUN mkdir -p /docker-entrypoint-initdb.d
# COPY ./initdb-pg_partman.sh /docker-entrypoint-initdb.d/10_pg_partman.sh

# Label information
LABEL maintainer=" postgres:17.0-bookworm-partman"
