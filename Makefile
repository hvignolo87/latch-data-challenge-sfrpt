CHECK_COMPOSE_PLUGIN := $(shell \
(test -e $(HOME)/.docker/cli-plugins/docker-compose) || \
(test -e /usr/local/lib/docker/cli-plugins/docker-compose) || \
(test -e /usr/lib/docker/cli-plugins/docker-compose) || \
(test -e /usr/libexec/docker/cli-plugins/docker-compose) 2> /dev/null; echo $$?)
COMPOSE_FILE_OPT = -f ./docker-compose.yaml
ifeq ($(CHECK_COMPOSE_PLUGIN), 0)
    DOCKER_COMPOSE_CMD = docker compose $(COMPOSE_FILE_OPT)
else
    DOCKER_COMPOSE_CMD = docker-compose $(COMPOSE_FILE_OPT)
endif

_GREEN='\033[0;32m'
_NC='\033[0m'

define log
	@printf "${_GREEN}$(1)${_NC}\n"
endef


# Reference: https://www.padok.fr/en/blog/beautiful-makefile-awk
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Environment

.PHONY: generate-dotenv
generate-dotenv: ## Generate a new .env file (it overrides the existing one). Usage: make generate-dotenv
	$(call log, Generating .env file...)
	cp ./.env.example ./.env

.PHONY: install-poetry
install-poetry: ## Install poetry. Usage: make install-poetry
	$(call log, Installing poetry...)
	curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.6.1 python3 - && \
	export "PATH=${HOME}/.local/bin:${PATH}" && \
	poetry config virtualenvs.in-project true && \
	poetry --version

.PHONY: install-project
install-project: ## Install the project dependencies. Usage: make install-project
	$(call log, Installing project dependencies...)
	poetry install --no-interaction --all-extras --with dev --sync


##@ Linting & Formatting

.PHONY: lint-python
lint-python: ## Lint a Python file. Usage: make lint-python path="./path/to/my_file.py"
	$(call log, Linting $(path)...)
	poetry run ruff check $(path)
	poetry run mypy --config-file ./mypy.ini $(path)

.PHONY: format-python
format-python: ## Format a Python file. Usage: make format-python path="./path/to/my_file.py"
	$(call log, Formatting $(path)...)
	poetry run black $(path)

.PHONY: lint-sql
lint-sql: ## Lint a SQL file. Usage: make lint-sql path="./path/to/my_file.sql"
	$(call log, Linting $(path)...)
	poetry run sqlfluff lint --config ./.sqlfluff $(path)

.PHONY: fix-sql
fix-sql: ## Apply fixes to a SQL file. Usage: make fix-sql path="./path/to/my_file.sql"
	$(call log, Fixing $(path)...)
	poetry run sqlfluff fix --force --config ./.sqlfluff $(path)

.PHONY: format-sql
format-sql: ## Format a SQL file. Usage: make format-sql path="./path/to/my_file.sql"
	$(call log, Formatting $(path)...)
	poetry run sqlfluff format --config ./.sqlfluff $(path)


##@ Docker

.PHONY: build
build: ## Build docker-defined services, can be passed specific service(s) to only build those. Usage: make build services="postgres"
	$(call log, Building images...)
	$(DOCKER_COMPOSE_CMD) build $(services)

.PHONY: up
up: ## Create docker-defined services, can be passed specific service(s) to only start those. Usage: make up services="postgres"
	$(call log, Creating services in detached mode...)
	$(DOCKER_COMPOSE_CMD) up -d $(services)

.PHONY: start
start: ## Start docker-defined services, can be passed specific service(s) to only start those. Usage: make start services="postgres"
	$(call log, Starting services...)
	$(DOCKER_COMPOSE_CMD) start $(services)

.PHONY: stop
stop: ## Stop docker-defined services, can be passed specific service(s) to only stop those. Usage: make stop services="postgres"
	$(call log, Stopping services $(services)...)
	$(DOCKER_COMPOSE_CMD) stop $(services)

.PHONY: down
down: ## Delete docker-defined services, can be passed specific service(s) to only delete those. Usage: make down services="postgres"
	$(call log, Deleting services $(services)...)
	$(DOCKER_COMPOSE_CMD) down $(services) --volumes

.PHONY: clean
clean: down ## Delete containers and volumes
	$(call log, Deleting services and volumes...)
	docker volume prune --all --force

.PHONY: prune
prune: ## Delete everything in docker
	$(call log, Deleting everything...)
	docker system prune --all --volumes --force && docker volume prune --all --force
