# Build stage to install node modules
FROM node:latest AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY src/ ./src/


# Set Chainguard Nginx as the base image
#FROM cgr.dev/chainguard/nginx:latest
FROM nginx:latest

# Set the user to 65532
USER 65532

# Copy static files and node_modules to Nginx server
COPY --from=build /app/src/ /usr/share/nginx/html/
COPY --from=build /app/node_modules/bootstrap/dist/ /usr/share/nginx/html/node_modules/bootstrap/dist/
COPY --from=build /app/node_modules/jquery/dist/ /usr/share/nginx/html/node_modules/jquery/dist

EXPOSE 8080