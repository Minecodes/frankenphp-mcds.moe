FROM --platform=linux/amd64 dunglas/frankenphp:static-builder

# Define build arguments
ARG PHP_EXTENSIONS
ARG PHP_EXTENSION_LIBS
ARG XCADDY_ARGS
ARG EMBED

# Copy your app
WORKDIR /go/src/app/dist/app
COPY . .

# Build the static binary
WORKDIR /go/src/app/
RUN EMBED=${EMBED} \
    PHP_EXTENSIONS=${PHP_EXTENSIONS} \
    PHP_EXTENSION_LIBS=${PHP_EXTENSION_LIBS} \
    XCADDY_ARGS=${XCADDY_ARGS} \
    ./build-static.sh
