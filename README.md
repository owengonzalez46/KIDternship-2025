# KIDternship-2025 🚀

![Docker](https://img.shields.io/badge/docker-ready-blue?logo=docker)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-blue?logo=postgresql)
![Flask](https://img.shields.io/badge/Flask-API-green?logo=flask)
![MIT License](https://img.shields.io/badge/license-MIT-green)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)

Welcome to **KIDternship-2025**!  

Welcome to **KIDternship-2025**!  
This project is a fun, hands-on playground designed to help "kidterns" (student interns) learn the basics of database operations and backend development using modern tools like Docker, Flask, and PostgreSQL. 

## 🧑‍💻 What is KIDternship-2025?

KIDternship-2025 simulates a real-world backend system where a Flask API server acts as a secure gateway, forwarding SQL queries (SELECT, UPDATE, DELETE, INSERT) to a PostgreSQL database. The database is pre-populated with:

- **100 student tables**: `student1`–`student100`  
- **1 main table**: `storeOwners`

This setup allows you to experiment with database queries, see how data flows between an API and a database, and understand the importance of authentication and data management.

## 📦 Project Structure

```
KIDternship-2025/
  flask_docker_kidternship/      # Flask API server (Python)
  postgres_docker_kidternship/   # PostgreSQL database
```

## 🚦 Getting Started

### 1️⃣ Start the PostgreSQL Database

Open a terminal and navigate to the `postgres_docker_kidternship` directory:

```sh
cd postgres_docker_kidternship
docker-compose up -d
```

### 2️⃣ Start the Flask API Server

Open a new terminal and navigate to the `flask_docker_kidternship` directory:

```sh
cd flask_docker_kidternship
docker-compose up -d
```

### 3️⃣ Initialize the Database Tables

After both containers are running, initialize the tables by running:

```sh
cd postgres_docker_kidternship
bash createStudents.sh
```

This will create tables `student1`–`student100` and the `storeOwners` table, and populate them with example data.

---

## 🔄 Resetting the Database
- To **reset the database** (drop all tables and recreate them with initial data):  
  ```sh
  bash resetTables.sh
  ```

---

## 🛠️ Usage

- The Flask server listens on port **3000** (mapped to `5000` in the container).
- You can send SQL queries (SELECT, UPDATE, DELETE, INSERT) to the Flask API, which will forward them to the database.
- **Authentication** is required for each table (see `authenticationTable.py`).

---

## 📝 Notes & Tips

- Environment variables for database connection are set in the `.env` files in each directory.
- Logs are stored in the `logs/` directory inside `flask_docker_kidternship`.
- For more details on the API, see `app.py`.
- Try experimenting with different queries and see how the data changes!
- If you get stuck, check the logs or ask a mentor for help.

---

## 🌟 Why is this cool?

- **Real-world experience**: Learn how modern web apps connect to databases.
- **Safe sandbox**: Break things, reset, and try again—no worries!
- **Teamwork**: Collaborate with other kidterns and share what you discover.
- **Dockerized**: No messy installs—just run and learn!

---

Happy learning and hacking! 🎉  
*— The KIDternship Team*