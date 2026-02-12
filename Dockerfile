FROM node:22-alpine
RUN apk update && apk upgrade && \
    npm install -g npm@latest

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY app.js .

EXPOSE 8080

CMD [ "node", "app.js" ]