# syntax=docker/dockerfile:1.6

ARG NODE_VERSION=20-alpine

FROM node:${NODE_VERSION} AS base
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1
WORKDIR /app
RUN apk add --no-cache libc6-compat

FROM base AS deps
ENV NODE_ENV=development
COPY package*.json ./
# Install dependencies; prefer ci if lockfile is present, but fall back to install if out-of-sync
RUN npm ci --no-audit --no-fund || npm install --no-audit --no-fund

# Development image with hot reload
FROM deps AS dev
ENV NODE_ENV=development \
    WATCHPACK_POLLING=true
COPY . .
EXPOSE 3000 9229
CMD ["npm", "run", "dev"]

# Build the app
FROM deps AS builder
ENV NODE_ENV=production
COPY . .
RUN npm run build

# Production runtime image using Next standalone output
FROM node:${NODE_VERSION} AS runner
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -G nodejs -u 1001

# Copy necessary files from builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

USER 1001
EXPOSE 3000
CMD ["node", "server.js"]
