import psycopg2
import uuid
import random
import os
import logging

from flask import jsonify
from psycopg2 import sql, Error
from psycopg2.errors import UniqueViolation

databaseHost =  os.getenv('DATABASE_HOST')
databasePort =  os.getenv('DATABASE_PORT')
databasename = os.getenv('DATABASE_NAME')
authacct =  os.getenv('DATABASE_USER')
authacctpwd =  os.getenv('DATABASE_PASS')


def executeDatabase(query):
    try:
        # Basic sanitation: allow only specific types of SQL queries
        allowed_commands = ('select', 'update', 'delete', 'insert')
        if not any(query.strip().lower().startswith(cmd) for cmd in allowed_commands):
            raise ValueError("Unsupported SQL command.")

        print("Attempting to connect to PostgreSQL...")

        # Establish the database connection
        with psycopg2.connect(
            host=databaseHost,
            port=databasePort,
            user=authacct,
            password=authacctpwd,
            database=databasename
        ) as databaseConnection:
            logging.info("Connected to PostgreSQL database.")

            with databaseConnection.cursor() as databaseCursor:
                databaseCursor.execute(query)

                if query.strip().lower().startswith("select"):
                    results = databaseCursor.fetchall()
                    colnames = [desc[0] for desc in databaseCursor.description]
                    return [dict(zip(colnames, row)) for row in results], 200
                else:
                    databaseConnection.commit()
                    return {"message": "success"}, 200
    except UniqueViolation as e:
        return{"message":"Duplicate Primary Key Entry"}, 400
    except (Error, ValueError) as e:
        logging.error(f"Exception type: {type(e)}")
        return None