# 1. React 앱 빌드
FROM node:20 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . ./
RUN npm run build

# 2. Nginx로 배포
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html  # dist 경로 수정
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
