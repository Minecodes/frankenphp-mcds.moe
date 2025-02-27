#!/usr/bin/bash

# Check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
    echo 'Error: docker is not installed.' >&2
    exit 1
fi

# Check if using docker without sudo
if [ "$(id -u)" -ne 0 ]; then
    echo 'Error: Please run as root.' >&2
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo 'Error: .env file not found.' >&2
    exit 1
fi

mkdir -p dist
rm -rf dist/*

# Load environment variables from .env file
set -a
source .env
set +a

# Build the docker image using buildx bake
docker buildx bake --set static-builder.args.PHP_EXTENSIONS="${PHP_EXTENSIONS}" --set static-builder.args.PHP_EXTENSION_LIBS="${PHP_EXTENSION_LIBS}" --set static-builder.args.XCADDY_ARGS="${XCADDY_ARGS}" --set static-builder.args.EMBED="${EMBED}" static-builder

if [ $? -eq 0 ]; then
    docker cp $(docker create --name static-app-tmp static-app):/go/src/app/dist/frankenphp-linux-x86_64 dist/frankenphp
    docker rm static-app-tmp
    docker image rm static-app
    cd dist
    cp frankenphp caddy
    chmod +x *
    cd ..
    echo 'Docker build succeeded.'
else
    echo 'Docker build failed.' >&2
    exit 1
fi