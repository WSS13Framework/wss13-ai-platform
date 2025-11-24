FROM node:20-alpine

RUN apk add --no-cache openssl openssl-dev curl

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build || true

EXPOSE 3000

CMD ["npm", "start"]
