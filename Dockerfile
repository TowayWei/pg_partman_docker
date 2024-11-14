# Stage 1: Build pg_partman from source
FROM postgres:17.0-bookworm AS builder

RUN apt-get update && apt-get install -y \
    postgresql-server-dev-all \
    build-essential \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pgpartman/pg_partman.git /pg_partman && \
    cd /pg_partman && \
    make && \
    make install

# Stage 2: Copy built files into a clean PostgreSQL image
FROM postgres:17.0-bookworm

# Copy compiled pg_partman extension from the builder stage
COPY --from=builder /usr/share/postgresql/extension/pg_partman* /usr/share/postgresql/extension/
COPY --from=builder /usr/lib/postgresql/17/lib/pg_partman* /usr/lib/postgresql/17/lib/

# Clean up
RUN apt-get update && apt-get install -y postgresql-contrib && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# (Optional) Add additional configurations for pg_partman
