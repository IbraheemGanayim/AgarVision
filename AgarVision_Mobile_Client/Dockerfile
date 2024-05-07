# Build environment
FROM debian:latest AS build-env

# Install dependencies and configure git
RUN apt-get update && \
    apt-get install -y curl git unzip && \
    git config --global http.postBuffer 524288000 && \
    rm -rf /var/lib/apt/lists/*

ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.16.5
ARG APP=/app/

# Clone and set Flutter SDK
RUN git clone --depth 1 --branch $FLUTTER_VERSION https://github.com/flutter/flutter.git $FLUTTER_SDK

ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Run Flutter doctor
RUN flutter doctor -v

# Copy the application files and build the app
COPY . $APP
WORKDIR $APP

RUN flutter clean && \
    flutter pub get && \
    flutter build web --web-renderer html --release

# Nginx deployment
FROM nginx:1.25.2-alpine
COPY --from=build-env /app/nginx/default.conf /etc/nginx/conf.d/
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80

# Use environment variable for port setting in Nginx configuration
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'