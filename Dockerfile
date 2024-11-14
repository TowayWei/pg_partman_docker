# Stage 1: Build pg_partman
FROM postgres:17.0-bookworm AS builder

# Update and install build dependencies individually to troubleshoot
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y git && \
    apt-get install -y build-essential && \
    apt-get install -y postgresql-server-dev-17 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pgxnclient for installing extensions via PGXN
RUN curl -L https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.1.tar.gz | tar zx && \
    cd pgxnclient-1.3.1 && \
    python3 setup.py install && \
    rm -rf /pgxnclient-1.3.1

# Use pgxn to install and build pg_partman extension
RUN pgxn install pg_partman

# Stage 2: Create the final image
FROM postgres:17.0-bookworm

# Copy pg_partman extension files from the build stage
COPY --from=builder /usr/share/postgresql/extension/pg_partman* /usr/share/postgresql/extension/
COPY --from=builder /usr/lib/postgresql/17/lib/pg_partman* /usr/lib/postgresql/17/lib/

# Set environment variable to ensure Postgres loads pg_partman extension
ENV POSTGRESQL_PARTMAN_ENABLED=true

# Display pg_partman version to verify successful installation
RUN psql -c "CREATE EXTENSION IF NOT EXISTS pg_partman"
