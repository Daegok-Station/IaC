#!/bin/bash             # user_data가 bash로 실행된다는 걸 명시하기 위함
# OS 패키지 업데이트
sudo yum update -y

# Docker 설치
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker

# ec2-user를 Docker 그룹에 추가
sudo usermod -aG docker ec2-user

# Jenkins 작업 디렉터리 생성
mkdir -p /home/ec2-user/jenkins-docker
mkdir -p /home/ec2-user/jenkins_home
sudo chown -R 1000:1000 /home/ec2-user/jenkins_home

# Dockerfile 위치로 이동 (필요 시 Git clone)
cd /home/ec2-user/jenkins-docker

# Docker 이미지 빌드
docker build -t my-jenkins:custom .

# Jenkins 컨테이너 실행
docker run -d -p 8080:8080 \
  -v /home/ec2-user/jenkins_home:/var/jenkins_home \
  --name jenkins my-jenkins:custom
