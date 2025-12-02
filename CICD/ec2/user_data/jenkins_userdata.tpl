#!/bin/bash

# 1. OS 패키지 업데이트
sudo yum update -y

# 2. Docker 설치 및 활성화
sudo dnf install docker -y          # Amazon Linux 2023 기준 dnf 사용
sudo systemctl enable docker
sudo systemctl start docker

# 3. ec2-user를 Docker 그룹에 추가
sudo usermod -aG docker ec2-user

# 4. Jenkins 작업 디렉터리 생성
mkdir -p /home/ec2-user/jenkins-docker
mkdir -p /home/ec2-user/jenkins_home
sudo chown -R 1000:1000 /home/ec2-user/jenkins_home

# 5. Dockerfile 위치로 이동 (필요 시 Git clone)
cd /home/ec2-user/jenkins-docker
# 예: 필요하다면 Dockerfile Git에서 가져오기 가능
# git clone <dockerfile_repo_url> .

# 6. Docker 이미지 빌드
docker build -t my-jenkins:custom .

# 7. Jenkins 컨테이너 실행
docker run -d -p 8080:8080 \
  -v /home/ec2-user/jenkins_home:/var/jenkins_home \
  --name jenkins my-jenkins:custom

# 8. Jenkins CLI 다운로드
docker exec jenkins curl -sSL http://localhost:8080/jnlpJars/jenkins-cli.jar -o /var/jenkins_home/jenkins-cli.jar

# 9. Git 기반 Pipeline Job 생성
#    - Jenkinsfile이 저장된 Git URL과 브랜치 지정
#    - Job 이름: my-pipeline
cat > /home/ec2-user/jenkins-docker/my-pipeline.xml <<'EOF'
<flow-definition plugin="workflow-job@2.45">
  <description>Spring Petclinic CI/CD Pipeline</description>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.1007">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.15.0">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/Daegok-Station/Jenkins-Deploy.git</url>
          <credentialsId></credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>codepipeline/Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
</flow-definition>
EOF

# 10. Jenkins CLI로 Job 생성
docker exec jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s http://localhost:8080 create-job my-pipeline < /home/ec2-user/jenkins-docker/my-pipeline.xml

# 11. 최초 빌드 실행
docker exec jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s http://localhost:8080 build my-pipeline
