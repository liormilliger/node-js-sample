FROM node:22.1.0-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY app.js .

EXPOSE 8080

CMD [ "node", "app.js" ]