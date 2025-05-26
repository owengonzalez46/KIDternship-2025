from flask import Flask, request, jsonify, send_file, Response
from logging.handlers import RotatingFileHandler
from flask_socketio import SocketIO, emit
from flask_cors import CORS

import databaseManagement
import authenticationTable
import fileOperations
import logging
import random
import os
import re
from datetime import datetime

# Initialize Flask app
app = Flask(__name__)


# Setup log directory and file
log_dir = os.path.join("logs", datetime.now().strftime('%Y'), datetime.now().strftime('%m'))
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, datetime.now().strftime('%Y-%m-%d') + ".log")

# Configure RotatingFileHandler
file_handler = RotatingFileHandler(log_file, maxBytes=10*1024*1024, backupCount=5)
file_handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(message)s')
file_handler.setFormatter(formatter)

# Attach handler to Flask's logger
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)


CORS(app)  # Enable Cross-Origin Resource Sharing
socketio = SocketIO(app, cors_allowed_origins="*")  # Initialize Socket.IO with CORS support

# Root route to provide basic information
@app.route('/')
def index():
    return 'Welcome to the API!'

@app.route('/run-query', methods=['POST'])
def run_query():
    try:
        data = request.get_json()
        query = data.get("query", "")
        app.logger.info(f"Received query: {query}")
        username = data.get("username", "")
        app.logger.info(f"Received username: {username}")
        password = data.get("password", "")
        app.logger.info(f"Received password: {password}")
        
        match = re.search(r'public\.(\S+)', query)

        if match:
            tableName = match.group(1)

        if username:
            userAuthenticated = False
            for table in authenticationTable.tables:
                if table["tableName"] == tableName:
                    app.logger.info(f"Found tableName: {tableName}")
                    if table["username"] == username.strip().lower() and table["password"] == password.strip().lower():
                        userAuthenticated = True
            if not userAuthenticated:
                message = "User not allowed to call table: " + tableName
                return jsonify({"message": message}), 401

        if not query:
            app.logger.error("No query provided in the request.")
            return jsonify({"message": "No query provided"}), 400

        # Call your sanitized database execution function
        result, statusCode = databaseManagement.executeDatabase(query)
        app.logger.info(f"Query result: {result}")

        if result is None:
            app.logger.error("No results or database error occurred.")
            return jsonify({"message": "No results or error occurred"}), 204
        
        return jsonify({"message": result}), statusCode
    except Exception as e:
        app.logger.error(f"Error processing request: {e}")
        return jsonify({"message": str(e)}), 500

# Main entry point to run the Flask app with Socket.IO support
if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", debug=True, allow_unsafe_werkzeug=True)
