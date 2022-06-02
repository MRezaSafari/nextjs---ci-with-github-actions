FROM node:current-alpine AS base
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

FROM base as build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /app ./
RUN npm run build

FROM node:current-alpine as production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package*.json ./
COPY --from=build /build/.next ./.next
COPY --from=build /build/public ./public
RUN npm install next

EXPOSE 3000
CMD [ "npm", "run", "start"]