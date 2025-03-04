# 1. Node.js 20 환경에서 빌드
FROM node:20 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# 2. Nginx로 배포
FROM nginx:alpine
COPY --from=builder /dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
