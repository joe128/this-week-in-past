# # # # # # # # # # # # # # # # # # # #
# Builder
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM docker.io/rust:alpine as builder

# Create a cache directory that will be copied into the final image
RUN mkdir "/cache"

# Install ssl certificates that will also be copied into the final image
RUN apk update && apk add --no-cache alpine-sdk ca-certificates

# Update crates io index via git cli, otherwise we'll an out of memory when building for arm https://github.com/rust-lang/cargo/issues/9167
RUN mkdir -p ~/.cargo/
RUN echo "[net]" > ~/.cargo/config
RUN echo "git-fetch-with-cli = true" >> ~/.cargo/config

# Prepare build dir
RUN mkdir /app
WORKDIR /app

# Copy app sources
COPY Cargo.toml Cargo.lock /app/
COPY src/ /app/src

# Build the application
RUN cargo build --release

# # # # # # # # # # # # # # # # # # # #
# Run image
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM alpine as runtime

ENV CACHE_DIR "/cache"
ENV RESOURCE_PATHS "/resources"

VOLUME /cache

# Create an empty cache directory
COPY --chown=1337:1337 --from=builder /cache /cache

# Copy ssl certificates to the scratch image to enable HTTPS
COPY --chown=1337:1337 --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the built application from the host to the container
COPY --chown=1337:1337 --from=builder /app/target/release/this-week-in-past /this-week-in-past

# Copy the static html website data from the host to the container
COPY --chown=1337:1337 ./static /static

EXPOSE 8080
USER 1337

CMD ["/this-week-in-past"]