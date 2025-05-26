#!/bin/bash

# Load environment variables from .env file
if [[ -f ./.env ]]; then
  source ./.env
else
  echo "Error: .env file not found!"
  exit 1
fi

# Example products with extended attributes
PRODUCTS=(
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'latte', 'coffee', 'vanilla, original, hazelnut, peppermint, caramel', 'small, medium, large', 'hot, iced');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'cappuccino', 'coffee', 'vanilla, original, hazelnut, peppermint, caramel', 'small, medium, large', 'hot, iced');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'espresso', 'coffee', 'none', '2-shots, 3-shots, 4-shots', 'hot');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'mocha', 'coffee', 'chocolate, white chocolate', 'small, medium, large', 'hot, iced');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'muffin', 'baked good', 'blueberry, raspberry, plain', 'regular', 'room temperature, warm');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'croissant', 'baked good', 'chocolate, plain', 'regular', 'room temperature, warm');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'scone', 'baked good', 'blueberry, chocolate, plain', 'regular', 'room temperature, warm');"
  "INSERT INTO public.menu (uuid, menuitem, category, flavor, size, temperature) VALUES (uuid_generate_v4(), 'cookie', 'baked good', 'chocolate, sugar, pecan', 'regular', 'room temperature, warm');"
  "INSERT INTO public.orders (orderid, status, item, flavor, size, temperature, notes) VALUES ('123', 'open', 'latte', 'vanilla', 'medium', 'iced', '');"
  "INSERT INTO public.orders (orderid, status, item, flavor, size, temperature, notes) VALUES ('124', 'in progress', 'cappuccino', 'hazelnut', 'medium', 'hot', '');"
  "INSERT INTO public.orders (orderid, status, item, flavor, size, temperature, notes) VALUES ('125', 'closed', 'muffin', 'blueberry', 'regular', 'warm', '');"
  "INSERT INTO public.orders (orderid, status, item, flavor, size, temperature, notes) VALUES ('126', 'open', 'espresso', 'none', '2-shots', 'hot', '');"
)

# Export the password to avoid being prompted
export PGPASSWORD=$DATABASE_PASS

# Function to execute SQL command and handle errors
execute_sql() {
  local command="$1"
  psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" -d "$DATABASE_NAME" -c "$command"
  local status=$?
  if [ $status -ne 0 ]; then
    echo "Error: Failed to execute SQL command: $command"
    exit $status
  fi
}

# Truncate the menu table
execute_sql "TRUNCATE TABLE public.menu;"
execute_sql "TRUNCATE TABLE public.orders;"

# Insert example products
for product in "${PRODUCTS[@]}"; do
  execute_sql "$product"
done

# Clear the contents of posts.json and posts.log
> "$POSTS_JSON_FILE"
> "$POSTS_LOG_FILE"

echo "Database has been truncated, example products have been inserted, and posts files have been cleared."

# Unset the password environment variable
unset PGPASSWORD
