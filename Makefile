.DEFAULT_GOAL := help

export BUILD_OPTIONS=${BUILD_OPTIONS:-}
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export BRIDGE_URL=https://downloads.tableau.com/tssoftware/TableauBridge-20261.26.0226.1626.x86_64.rpm

.PHONY: help build test up down clean logs status shell-bridge db-client

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build         Download Tableau bridge and Build the containers"
	@echo "  up            Start the containers in the background"
	@echo "  down          Stop and remove the containers (keeps database data)"
	@echo "  clean         Stop containers AND destroy the database volume (resets init.sql)"
	@echo "  logs          Tail the logs for the Tableau Bridge container"
	@echo "  status        Check the running status of your containers"
	@echo "  shell         Open a bash shell inside the Tableau Bridge container"
	@echo "  db-client     Open the PostgreSQL CLI inside the database container"

tableau-bridge.rpm:
	curl -L -o tableau-bridge.rpm $(BRIDGE_URL)

build: tableau-bridge.rpm
	docker compose build ${BUILD_OPTIONS}

test:
	@echo "NOOP: no test system implemented for tableau bridge."

up:
	docker-compose up -d

down:
	docker-compose down

clean:
	docker-compose down -v

logs:
	docker logs -f govwifi-tableau-bridge

status:
	docker-compose ps

shell:
	docker exec -it govwifi-tableau-bridge /bin/bash

db-client:
	docker exec -it local-postgres psql -U tableau_user -d tableau_test_db
