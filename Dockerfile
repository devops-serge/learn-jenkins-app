FROM mcr.microsoft.com/playwright:v1.39.0-jammy

WORKDIR /usr/app

RUN npm install netlify-cli@20.1.1 node-jq serve