
# 1 - Script to deploy Jenkins + Docker
# https://raw.githubusercontent.com/wardviaene/jenkins-course/master/scripts/install_jenkins.sh

wget https://raw.githubusercontent.com/wardviaene/jenkins-course/master/scripts/install_jenkins.sh
bash install_jenkins.sh

# 2 - Jenkins + NodeJS without docker
# https://github.com/wardviaene/docker-demo
	mkdir -p /var/jenkins_home
	chown -R 1000:1000 /var/jenkins_home/
	docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts
	cat /var/jenkins_home/secrets/initialAdminPassword
	cd /var/jenkins_home/


# 3 - Jenkins + NodeJS WITH  docker
#  https://github.com/wardviaene/jenkins-docker

cd /var/jenkins_home/
git clone https://github.com/wardviaene/jenkins-docker
cd jenkins-docker
# See group ID for docker:
dockerGID=$(getent group docker | awk -F: '{printf "Group %s with GID=%d\n", $1, $3}' | cut -f2- -d "=")
sed -i '/ groupadd -g 999 docker/c\ groupadd -g $dockerGID docker && \\' /var/jenkins_home/jenkins-docker/Dockerfile
docker build -t jenkins-docker .
docker stop jenkins
docker rm jenkins
cd /var/jenkins_home/

docker run \
-p 8080:8080 \
-p 50000:50000 \
--restart unless-stopped  \
-v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-d \
--name jenkins \
jenkins-docker

# To test:
docker exec  jenkins docker ps 





/*

Manual Build:
mvn clean install
# It creates a .war file

-------------------------------------------------------------------------------------------------
1 - Guided Install:
mkdir /var/jenkins_home
cd /var/jenkins_home
git clone https://github.com/wardviaene/jenkins-docker
cd jenkins-docker
sed -i '/ groupadd -g 999 docker/c\ groupadd -g 120 docker && \\' /var/jenkins_home/jenkins-docker/Dockerfile
docker build -t jenkins-docker .
docker stop jenkins
docker rm Jenkins
ls /var/jenkins_home

2 - Jenkins Install on Docker:
mkdir -p /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home/
docker run \
-p 8081:8080 \
-p 50000:50000 \
--restart unless-stopped  \
-v /var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-d \
--name jenkins \
jenkins-docker


Give permissions to jenkins to talk with the docker daemon:
	FROM jenkins/jenkins:lts
	USER root
	
	RUN mkdir -p /tmp/download && \
	 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /tmp/download && \
	 rm -rf /tmp/download/docker/dockerd && \
	 mv /tmp/download/docker/docker* /usr/local/bin/ && \
	 rm -rf /tmp/download && \
	 groupadd -g 120 docker && \
	 usermod -aG staff,docker jenkins
	
	USER jenkins


sudo service docker stop # to stop the service
sudo docker -d --insecure-registry 192.168.1.200:5000

# show endpoint
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'
-------------------------------------------------------------------------------------------------


To push into docker hub:
docker login -u gil906
Password:  ACCESS TOKEN
docker push gil906/docker-example-nodejs:latest

docker build -t hub.docker.com/gil906/docker-example-nodejs --pull=true /var/jenkins_home/workspace/docker-example


Running NEW:
#Jenkins - Server
docker run -d \
--name jenkins-docker \
-p 8081:8080 \
-p 50000:50000 \
--restart unless-stopped  \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /mnt/media/jenkins/data:/var/jenkins_home \
jenkins-docker


Running:
#Jenkins - Server
docker run -d \
--name jenkins \
-p 8081:8080 \
-p 50000:50000 \
--restart unless-stopped  \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /mnt/media/jenkins/data:/var/jenkins_home \
jenkins/jenkins

User: gil906
Password: 3?=WB!5>qWcv'H3y


Tomcat on Docker:
#Latest Version (Tomcat 10):
docker run -d\
-it --rm \
-p 8888:8080 \
tomcat:latest

# With Enviroments:
docker run -d\
-it --rm \
-p 8888:8080 \
-e CATALINA_BASE=/mnt/media/tomcat
-e CATALINA_HOME=/mnt/media/tomcat
-e CATALINA_TMPDIR=/mnt/media/tomcat/temp
-e JRE_HOME=/mnt/media/tomcat/
-e CLASSPATH=/mnt/media/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
tomcat:latest


#Tomcat 9:
docker run -it --rm -p 8888:8080 tomcat:9.0

https://hub.docker.com/_/tomcat


#Default paths:
CATALINA_BASE:   /usr/local/tomcat
CATALINA_HOME:   /usr/local/tomcat
CATALINA_TMPDIR: /usr/local/tomcat/temp
JRE_HOME:        /usr
CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar




Install docker and Jenkins as container script - Ubuntu:

#!/bin/bash

# this script is only tested on ubuntu focal 20.04 (LTS)

# install docker
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# run jenkins
mkdir -p /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home/
docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts

# show endpoint
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'



*/



