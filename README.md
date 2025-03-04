# 프런트엔드 Docker Compose 자동 배포 스터디

회사 팀원 분께 도움을 받아 기억 저편으로 넘어갈 뻔한 도커 공부를 했다. 도커 개념을 다시 정리하고, 실제 프런트엔드 프로젝트에서 적용할 만한 내용을 중심으로 실습을 진행했다.

실제 서버에 자동 배포를 구현해야 했지만, 로컬에서 테스트하기 위해 `ssh` 접속 없이 Docker Compose에서 `watchtower`를 활용하여 이미지가 자동으로 업데이트되도록 설정했다.

## 구현 로직

깃허브 레파지토리 푸시

1. `GitHub Actions`를 통해 도커 이미지 생성 후 도커 허브에 푸시
2. Docker Compose에서 `Watchtower` 컨테이너가 30초마다 새로운 이미지가 있는지 확인
3. 새로운 이미지가 감지되면 기존 컨테이너를 자동으로 중단하고 최신 이미지로 업데이트
4. 서비스가 자동으로 재시작되어 최신 버전이 반영됨

## 구성 파일

### 1. docker-compose.yml
```yml
version: '3'
services:
  app:
    image: kkusaeng/react-docker:latest  # 최신 이미지 유지
    container_name: react-app
    ports:
      - "8080:80"
    restart: always  # 컨테이너가 종료되면 자동 재시작

  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # 도커 컨트롤을 위해 필요
    command: --interval 30  # 30초마다 업데이트 확인
```
### 2. .github/workflows/docker-build.yml (GitHub Actions)
```yml
name: Docker Build and Push

on:
  push:
    branches:
      - main  # main 브랜치에 푸시될 때 실행

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}

      - name: Build Docker image
        run: docker build -t kkusaeng/react-docker:latest .

      - name: Push Docker image
        run: docker push kkusaeng/react-docker:latest
```

## 실행 방법

### 1. 초기 설정

- .env 파일을 생성하여 필요한 환경 변수 설정
- GitHub Secrets에서 DOCKER_HUB_USERNAME 및 DOCKER_HUB_ACCESS_TOKEN 설정

### 2. 로컬에서 실행 (docker-compose.yml 과 같은 경로에서)
```bash
docker-compose up -d  # 백그라운드 실행
docker-compose logs -f  # 실시간 로그 확인
```
### 3. 실행 중인 컨테이너 확인
```bash
docker ps
```
### 4. 컨테이너 중지 및 삭제
```bash
docker-compose down
```

## 로그

<img src="https://github.com/user-attachments/assets/4d5c71ee-40b6-4a26-8f02-f6f9b5cf789e" alt="도커 컴포즈 자동 배포" >
