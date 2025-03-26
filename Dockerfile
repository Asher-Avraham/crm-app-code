# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy files needed for installation
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy necessary source files
COPY next.config.js ./
COPY public ./public
COPY src ./src

# Build the application
RUN yarn build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy production dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

# Copy built application from builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Set production environment
ENV NODE_ENV=production

# Expose port 3000
EXPOSE 3000

# Run in production mode
CMD ["yarn", "start"]
