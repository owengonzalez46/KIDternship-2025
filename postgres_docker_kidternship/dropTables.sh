#!/bin/bash

# Load environment variables from .env
set -o allexport
source .env
set +o allexport

# Use DATABASE_HOST if PGHOST is not already set
PGHOST="${PGHOST:-$DATABASE_HOST}"
PGPORT="${PGPORT:-5432}"
export PGPASSWORD="$POSTGRES_PASSWORD"

# Check if psql is available
if ! command -v psql &> /dev/null; then
  echo "Error: psql is not installed or not in your PATH."
  exit 1
fi

# Test connection
echo "Testing database connection..."
if ! psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d "$PGDATABASE" -c '\q' 2>/dev/null; then
  echo "Error: Unable to connect to database with the provided credentials."
  exit 1
fi

echo "Connected. Truncating all student tables and public.storeOwners..."

# Drop shared main table
psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d "$PGDATABASE" -c "DROP TABLE public.storeOwners;"

# Loop and safely drop each student table
for i in $(seq 1 100); do
  USERNAME="student$i"
  echo "Checking and truncating public.${USERNAME}..."

  psql -U "$PGUSER" -h "$PGHOST" -p "$PGPORT" -d "$PGDATABASE" <<EOF
DO \$\$
BEGIN
   IF EXISTS (
      SELECT FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_name = '${USERNAME}'
   ) THEN
      EXECUTE 'DROP TABLE public.${USERNAME}';
   ELSE
      RAISE NOTICE 'Table public.${USERNAME} does not exist.';
   END IF;
END
\$\$;
EOF

done

echo "✅ All existing student tables and public.main have been reset (dropped)."
