#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Running dropTables.sh..."
bash dropTables.sh

echo "Running createStudents.sh..."
bash createStudents.sh

echo "✅ Tables dropped and recreated successfully."
