FROM cirrusci/flutter:stable AS build

WORKDIR /app
COPY . .

RUN flutter build web

# Serve with a simple web server
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80