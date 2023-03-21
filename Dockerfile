# Full build dockerfile
# Used for Release builds
FROM node:19-alpine AS builder

WORKDIR /app

COPY package.json package.json
RUN npm install

ARG API_ENDPOINT_ARG=http://localhost:8090
ENV VITE_ENDPOINT_URL=$API_ENDPOINT_ARG

COPY . .
RUN npm run build

FROM node:19-alpine
WORKDIR /app
RUN npm install serve --global
COPY --from=builder /app/dist .
CMD ["serve", "-p", "8080", "-s", "."]