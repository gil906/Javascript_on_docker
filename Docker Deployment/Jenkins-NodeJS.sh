
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
