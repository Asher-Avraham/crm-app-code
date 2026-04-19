# Production stage
FROM node:20-alpine

WORKDIR /app

# Copy files needed for installation
COPY package.json yarn.lock ./

# Install production dependencies
RUN yarn install --frozen-lockfile --production

# Copy built application and assets from the context
# These are generated in the CI pipeline (setup-and-build job)
COPY .next ./.next
COPY public ./public
COPY next.config.js ./

# Set production environment
ENV NODE_ENV=production

# Expose port 3000
EXPOSE 3000

# Run in production mode
CMD ["yarn", "start"]
