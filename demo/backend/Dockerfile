FROM node

WORKDIR /app

COPY package*.json ./
RUN npm install --quiet
RUN npm install --global nodemon

COPY . .

ENV NODE_ENV production
ENV PORT 3000
EXPOSE 3000

CMD ["node", "index.js"]
