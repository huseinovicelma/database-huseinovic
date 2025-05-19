FROM node:latest
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY app/package.json app/package-lock.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]