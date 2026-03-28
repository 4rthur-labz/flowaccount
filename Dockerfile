FROM node:24-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY . .

FROM node:24-alpine AS production
WORKDIR /app
RUN apk add --no-cache curl
RUN apk add --no-cache tini
RUN adduser -u 1001 -D app_user
USER app_user
COPY --from=builder --chown=app_user /app .

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
CMD curl -f http://localhost:3000/health || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]
