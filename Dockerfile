# Use an official Node.js runtime as the base image
FROM node:20-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and yarn.lock (or package-lock.json) to the working directory
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application code to the working directory
COPY . .

# Build the Next.js application
RUN yarn build

# Use a smaller base image for the final stage
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app ./

# Set the environment variable to production
ENV NODE_ENV=production

# Expose port 3000 to the outside world
EXPOSE 3000

# Define the command to run your application
CMD ["yarn", "start"]