FROM alpine AS build
WORKDIR /app
RUN apk add --no-cache curl tar
RUN curl -s https://api.github.com/repos/OpenAEC-Foundation/open-pdf-studio/releases/latest | grep "browser_download_url.*open-pdf-studio-web-.*\.tar\.gz\"" | cut -d : -f 2,3 | tr -d \" | xargs wget -qO bundle.tar.gz
RUN mkdir dist && tar -xzf bundle.tar.gz -C dist --strip-components=1

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
