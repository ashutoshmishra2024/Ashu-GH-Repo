#FROM node:16

# Create app directory
#WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
#COPY package*.json ./

#RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
#COPY . .

#EXPOSE 8080
#CMD [ "node", "server.js" ]

# base image

 FROM ubuntu:20.04
 
# #input GitHub runner version argument

 ARG RUNNER_VERSION

 ENV DEBIAN_FRONTEND=noninteractive
 
 LABEL BaseImage="ubuntu:20.04"

 LABEL RunnerVersion=${RUNNER_VERSION}
 
# # update the base packages + add a non-sudo user

 RUN apt-get update -y && apt-get upgrade -y && useradd -m docker
 
# install the packages and dependencies along with jq so we can parse JSON (add additional packages as necessary)

 RUN apt-get install -y --no-install-recommends \
     curl nodejs wget unzip vim git azure-cli jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip
 
# # cd into the user directory, download and unzip the github actions runner

 RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
 && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
 && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
 
# install some additional dependencies

 RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
 
# add over the start.sh script

 ADD start.sh start.sh
 
# make the script executable

 RUN chmod +x start.sh
 
# set the user to "docker" so all subsequent commands are run as the docker user

 USER docker
 
# set the entrypoint to the start.sh script

 ENTRYPOINT ["./start.sh"]
