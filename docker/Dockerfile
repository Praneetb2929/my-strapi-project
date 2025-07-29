FROM node:18-alpine

WORKDIR /app

COPY docker/package*.json ./
RUN npm install

COPY . .

EXPOSE 1337

CMD ["npm", "run", "develop"]