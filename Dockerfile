FROM node:12.8.1-alpine as builder

COPY . /home/node/diabloweb
RUN chown -R node: /home/node/diabloweb
RUN apk add --no-cache git jq moreutils

USER node
WORKDIR /home/node/diabloweb

ENTRYPOINT sh -c "while true; do sleep 10; done"

RUN jq '.homepage = "http://localhost/"' package.json | sponge package.json
RUN npm install
RUN npm run build


FROM nginx:1.17.3-alpine

COPY --from=builder /home/node/diabloweb/build /usr/share/nginx/html
