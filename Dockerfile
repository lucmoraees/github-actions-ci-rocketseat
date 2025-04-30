FROM node:20 AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY .yarn ./.yarn
RUN yarn install

COPY . .

RUN yarn global add @nestjs/cli
RUN yarn run build
RUN yarn install --production && yarn cache clean

FROM node:20-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start:prod"]