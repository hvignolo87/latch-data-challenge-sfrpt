# Data challenge resolution

[![Python 3.10.12](https://img.shields.io/badge/python-3.10.12-blue.svg?labelColor=%23FFE873&logo=python)](https://www.python.org/downloads/release/python-31012/) [![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://docs.astral.sh/ruff/) [![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://black.readthedocs.io/en/stable/) [![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)

In this document, you'll find information and instructions about my solution to the data challenge.

## Directories structure

This is the structure of the project.

```text
.
├── .dockerignore
├── .env.example
├── .python-version
├── .sqlfluff
├── .sqlfluffignore
├── Dockerfile
├── Makefile
├── README.md
├── data-challenge_sfrpt
│   ├── README.md
│   ├── crimes.sql
│   ├── loader.py
│   ├── queries.sql
│   ├── sf_crime_reports.jsonl
│   ├── sf_police_data_dictionary.pdf
│   └── view.sql
├── docker-compose.yaml
├── mypy.ini
├── poetry.lock
├── pyproject.toml
└── scripts
    └── postgres_init.sh
```

I've placed the queries directly inside the `data-challenge_sfrpt` directory.

## What you'll need

This solution is containerized, so you'll need to [install docker and docker-compose](https://docs.docker.com/get-docker/).

Also, it's recommended to have a desktop SQL client like [DBeaver](https://dbeaver.io/download/).

## Setup

Let's dive into the setup process.

### 1. Generate the environment variables

Open a shell in your machine, and navigate to this directory. Then run:

```bash
make generate-dotenv
```

This will generate the `.env` file. Please, go ahead and open it! It contains all the necessary environment variables. If you want to modify some values, just take into account that this may break some things.

### 2. Build the images

Run:

```bash
make build
```

This will build all the required images.

### 3. Create the services

Run:

```bash
make up
```

This will create a PostgreSQL database, the `crimes` table, and the `load-data` service that populates the table with the provided information.

### 4. Run the queries

Open DBeaver, and set up the connection to the database. If you didn't modified the `.env` file, you can use these credentials:

- User: `latch`
- Password: `latch`
- Host: `localhost`
- Port: `5440`
- DB: `sf_crime_reports`

Then, please open the `queries.sql` and `view.sql` files and run queries in DBeaver to verify the results.

If you don't have DBeaver, you can run the queries from PostgreSQL's terminal with [psql](https://www.postgresql.org/docs/13/app-psql.html). To do this, please run:

```bash
make execute-sql
```

Then you can run the queries from the terminal.

### 5. Stop or delete the services

Run:

```bash
make down
```

## Command's help

Run:

```bash
make help
```

## About the development tools

I've used [poetry](https://python-poetry.org/) to manage the project's dependencies. If you want to install it in your local machine, please run:

```bash
make install-poetry
```

And then run:

```bash
make install-project
```

Then you'll have all the dependencies installed, and a virtual environment created in this very directory. This is useful, for example, if you're using VS Code and want to explore the code. Also, you might want to use [pyenv](https://github.com/pyenv/pyenv) to install Python 3.10.12.

All the code in this project has been linted and formatted with these tools:

- [black](https://black.readthedocs.io/en/stable/)
- [isort](https://pycqa.github.io/isort/)
- [mypy](https://mypy.readthedocs.io/en/stable/)
- [ruff](https://docs.astral.sh/ruff/)
- [sqlfluff](https://docs.astral.sh/sqlfluff/)

## Additional information

You'll see that I've used [pandas](https://pandas.pydata.org/) and [sqlalchemy](https://www.sqlalchemy.org/) to easily handle the data population in the `crimes` table, as there were no restrictions to use it.

You'll notice that I've created some indexes in the `crimes` table. These indexes are useful for improving query performance, and the only reason I've created them is to show my understanding of how indexes work.
