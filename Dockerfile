FROM alpine/git AS git

WORKDIR /app

RUN git init
RUN git config core.sparsecheckout true
RUN git remote add origin https://github.com/thingbomb/feedbomb.git
RUN echo apps/web >> .git/info/sparse-checkout
RUN git pull origin main

FROM node:18-alpine

WORKDIR /app

COPY --from=git /app/apps/web /app

RUN npm install -g pnpm

RUN pnpm install
RUN pnpm build

EXPOSE 3000

CMD ["pnpm", "start"]

