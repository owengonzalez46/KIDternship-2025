#!/bin/bash

# Load .env file
set -o allexport
source .env
set +o allexport

# Validate essential environment variables
: "${DATABASE_HOST:?Missing DATABASE_HOST in .env}"
: "${POSTGRES_PASSWORD:?Missing POSTGRES_PASSWORD in .env}"
: "${PGUSER:?Missing PGUSER in .env}"
: "${PGDATABASE:?Missing PGDATABASE in .env}"

export PGPASSWORD="$POSTGRES_PASSWORD"

# Create storeOwners table
psql -U "$PGUSER" -h "$DATABASE_HOST" -d "$PGDATABASE" <<EOF
CREATE TABLE IF NOT EXISTS public.storeOwners (
    name VARCHAR PRIMARY KEY,
    color VARCHAR,
    animal VARCHAR
);
EOF
echo "Created table: public.storeOwners"

# Create and populate student1 to student100
for i in {1..100}; do
  TABLE="student$i"
  echo "Creating and populating: public.$TABLE"

  psql -U "$PGUSER" -h "$DATABASE_HOST" -d "$PGDATABASE" <<EOF
CREATE TABLE IF NOT EXISTS public.$TABLE (
    product VARCHAR PRIMARY KEY,
    quantity INTEGER,
    price NUMERIC(10, 2)
);

INSERT INTO public.$TABLE (product, quantity, price) VALUES
    ('Diamond Sword', 1, 199.99)
    ON CONFLICT (product) DO NOTHING;

INSERT INTO public.$TABLE (product, quantity, price) VALUES
    ('Dirt Block', 100, 0.99)
    ON CONFLICT (product) DO NOTHING;

INSERT INTO public.$TABLE (product, quantity, price) VALUES
    ('Watermelon', 3, 2.99)
    ON CONFLICT (product) DO NOTHING;
EOF

done

echo "✅ All tables created and populated successfully."
