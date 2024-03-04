FROM node:18-alpine AS build

#ARG user=DanielSystem&mpbet
#ARG uid=1001

#RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN apk clean &&  rm -rf /var/lib/apt/lists/*

#RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN npm install -g npm@10.4.0

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine AS runtime

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

ENV HOST=141.147.82.217
USER node
CMD ["npx", "serve"]
