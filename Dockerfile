# syntax=docker/dockerfile:1

# ---- Stage 1: fetch the pre-built web bundle from the latest GitHub release ----
FROM alpine AS build
WORKDIR /app
RUN apk add --no-cache curl tar

RUN curl -fsSL https://api.github.com/repos/OpenAEC-Foundation/open-pdf-studio/releases/latest \
      | grep -o '"browser_download_url": *"[^"]*open-pdf-studio-web-[^"]*\.tar\.gz"' \
      | head -n1 \
      | cut -d '"' -f4 \
      | xargs curl -fsSL -o bundle.tar.gz

RUN mkdir dist \
 && tar -xzf bundle.tar.gz -C dist \
 && test -f dist/index.html

# ---- Stage 2: serve the static files with nginx ----
FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
