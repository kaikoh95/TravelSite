FROM node:11.9.0-alpine as build

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN apk add --no-cache make gcc g++ python && \
  npm install --production --silent && \
  apk del make gcc g++ python
# Bundle app source
COPY . /usr/src/app
COPY wait-for-it.sh /


CMD /wait-for-it.sh db:3306 -- npm run docker
