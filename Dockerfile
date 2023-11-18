# syntax=docker/dockerfile:1
FROM python:3.10.12

USER root

ENV POETRY_VERSION="1.6.1" \
    PIP_ROOT_USER_ACTION="ignore" \
    PATH="${PATH}:/root/.local/bin"

WORKDIR /code

COPY . .

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=~/.cache/pip <<-EOF
    set -e
    apt-get -qy update
    apt-get -qy install cmake curl libpq-dev
    pip install -U pip
    curl -sSL https://install.python-poetry.org | POETRY_VERSION=${POETRY_VERSION} python3 -
    poetry config virtualenvs.in-project true
    poetry install --without dev --sync --no-interaction
EOF
