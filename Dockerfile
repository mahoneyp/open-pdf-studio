FROM node:22-bullseye-slim AS build

WORKDIR /app
COPY . .
WORKDIR /app/open-pdf-studio
RUN npm ci
RUN npm run build:hosted

FROM nginx:stable-alpine
COPY --from=build /app/open-pdf-studio/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
