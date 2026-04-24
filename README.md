# GovWifi Tableau Bridge

This repository provides a containerised environment for running the **Tableau Bridge** client alongside a local PostgreSQL database for testing and demonstration purposes.

Tableau Bridge is a piece of client software that runs on an internal network, enabling a secure connection between Tableau Cloud and data stored behind a firewall or in a Virtual Private Cloud (VPC).

## Features

* **Tableau Bridge Container (`govwifi-tableau-bridge`)**: Based on Amazon Linux 2023, this container installs the Tableau Bridge `.rpm` client and the PostgreSQL ODBC drivers needed to communicate with PostgreSQL databases.
* **Local PostgreSQL Container (`local-postgres`)**: A PostgreSQL 15 container that automatically initializes with demo sales data via `demo-data/init.sql`.

## Prerequisites

* Docker and Docker Compose
* A Tableau Cloud Site
* A Personal Access Token (PAT) generated in Tableau Cloud

## Setup & Configuration

1. **Obtain a Personal Access Token (PAT)**
   Create a PAT in Tableau Cloud. Ensure it's for a user domain/group that has privileges to use Tableau Bridge.

2. **Configure Authentication**
   You can provide the Personal Access Token (PAT) in two ways:

   **Option A: Environment Variable (Recommended for ECS)**
   Set the `TABLEAU_PAT_JSON` environment variable to the JSON string of your token:
   ```bash
   export TABLEAU_PAT_JSON='{"YOUR_TOKEN_NAME": "YOUR_TOKEN_SECRET_STRING_HERE"}'
   ```

   **Option B: Configuration File**
   Create a `pat.json` file. An example is provided.
   ```bash
   cp pat.json.example pat.json
   ```
   Edit `pat.json` so the key is the exact token name:
   ```json
   {
     "YOUR_TOKEN_NAME": "YOUR_TOKEN_SECRET_STRING_HERE"
   }
   ```

3. **Configure the Tableau Bridge Agent**
   Copy the sample environment file and update the values:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to match your Tableau Cloud details:
   * `TABLEAU_CLIENT`: A descriptive name for your bridge client (e.g., `GovWifiDataBridge`).
   * `TABLEAU_SITE`: The site name/ID from your Tableau Cloud URL (do not include the full URI).
   * `TABLEAU_USER_EMAIL`: The email address associated with your Tableau PAT.
   * `TABLEAU_PAT_TOKEN_ID`: Must match the token name from both Tableau Cloud and your token JSON.
   * `TABLEAU_POOL_ID`: (Optional) The Pool ID if assigning this client to a custom Bridge pool.
   * `TABLEAU_PAT_TOKEN_FILE`: (Optional) Path to the PAT file (defaults to `/app/pat.json`).

   *Note: These values can also be set directly in your shell environment. If `TABLEAU_PAT_JSON` is provided, the entrypoint script will automatically write it to `TABLEAU_PAT_TOKEN_FILE`.*

## Usage

A `Makefile` is provided to simplify Docker operations.

### 1. Build the Environment
Download the Tableau Bridge RPM and build the containers:
```bash
make build
```

### 2. Start the Services
Start the containers in the background:
```bash
make up
```
*(The Tableau Bridge agent expects the PostgreSQL database to be ready upon startup, `docker-compose` handles this ordering).*

### 3. Check Status and Logs
View running containers:
```bash
make status
```
Follow the logs of the Tableau Bridge container to confirm it has connected successfully to Tableau Cloud:
```bash
make logs
```

### 4. Connect to the Demo Database
You can open an interactive PostgreSQL prompt inside the database container to inspect the `tableau_test_db` tables:
```bash
make db-client
```

### 5. Debug the Tableau Bridge Container
Open a bash shell inside the Tableau Bridge container:
```bash
make shell
```

### 6. Stop and Clean Down
To gracefully stop the containers (retaining PostgreSQL database data):
```bash
make down
```

To stop the containers **and** delete the database volume (e.g., to reset the `init.sql` demo data):
```bash
make clean
```
