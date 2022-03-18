
#Step1: build the BASE image
FROM node:12-alpine AS base
LABEL developer=bibhup_mishra@yahoo.com
MAINTAINER Devops Engineer(bibhup_mishra@yahoo.com)
RUN mkdir -p /app 
# Set working directory within the base image. Paths will be relative this WORKDIR. 
WORKDIR /app
# Specify port app runs on
EXPOSE 8080


#Step2: build the intermittent BUILD image. This image does the heavy-lifting of package installation.  
#It will be rebuilt ONLY when there is a change in package dependency. Hence, it will save time when you rebuild the same image without a package change.
FROM node:12-alpine AS build
WORKDIR /src
# copy source files from host computer to container
COPY ["package.json", "package-lock.json*", "./"]
COPY . .
# Install dependencies and build app
RUN npm config set registry https://registry.npmjs.org/ && \
    npm install -g https://tls-test.npmjs.com/tls-test-1.0.0.tgz && \
    npm install --unsafe-perm=true --allow-root -y && \
    npm install 


#Step3: build the intermittent PUBLISH image. This image does the heavy-lifting of code compilling.  
#It will be rebuilt ONLY when there is a change in code. Hence, it will save time when you rebuild the same image without a code change.
FROM build AS publish
# Bundle app source
COPY . .
RUN npm run build

#Step4: build the final image from publish
FROM base AS final
COPY --from=publish /src .
# Set environment variable default value
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
