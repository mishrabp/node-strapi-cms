# Specifies which OS to use. Here it is unix OS pre-installed with node v-12
FROM ubuntu:latest
LABEL developer=bibhup_mishra@yahoo.com 
RUN apt-get update -y && \
    apt-get install curl -y && \
    curl -sL https://deb.nodesource.com/setup_12.x && \
    apt-get install nodejs -y && \
    apt-get install npm -y 
# create folder <app> inside the container image
#    mkdir -p /app 

# Set working directory within the image. Paths will be relative this WORKDIR. 
#WORKDIR /app

# copy source files from host computer to container
COPY ["package.json", "package-lock.json*", "./"]
COPY . .

# Install dependencies and build app
RUN npm config set registry https://registry.npmjs.org/ && \
    npm install -g https://tls-test.npmjs.com/tls-test-1.0.0.tgz && \
    npm install --unsafe-perm=true --allow-root -y && \
    npm install && \
    npm run build

# Specify port app runs on
EXPOSE 8081

# Set environment variable default value
ENV DATABASE_HOST="devopsmasterlinuxvm.centralus.cloudapp.azure.com" \
DATABASE_SRV=false \
DATABASE_PORT=9003 \
DATABASE_NAME=strapicms \
DATABASE_USERNAME=mongoadmin \
DATABASE_PASSWORD="passw0rd!" \
AUTHENTICATION_DATABASE="" \
DATABASE_SSL=false


# Run the app
CMD [ "npm", "start" ]
