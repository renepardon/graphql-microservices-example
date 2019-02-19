# GraphQL Microservices example with Remote Stitching using NodeJS and ExpressJS

This projects serves as an example project for Remote Stitching GraphQL instances together through a central GraphQL 
API. This is a great practice for easily connecting large nets of microservices and is easily maintainable.

> NOTE: In a real world project the `api-gateway`, `service-1` and `service-2` would be in it's own SCM repositories.

# Usage

## General

    npm install-all

Go into every service (new terminal windows) and run `npm run start`. When both services are running, start the API the 
same way. It's optimized for running in docker. So the endpoints within `api-gateway/server.js` need to be adjusted to 
*localhost:8082* and *localhost:8083* if you want to run it without docker.

## Docker

First create the `gme` network if it doesn't already exist. Then start all the services and the API gateway.

    docker network create gme
    docker-compose up -d

## kubernetes



