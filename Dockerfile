# Base image: postgres:17.0-bookworm
FROM postgres:17.0-bookworm

# Update and install pg_partman and related dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql-17-partman \
    && rm -rf /var/lib/apt/lists/*

# Label information
LABEL maintainer=" postgres:17.0-bookworm-partman"
