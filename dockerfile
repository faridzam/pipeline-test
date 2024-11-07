# Stage 1: Build the application
FROM node:18 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Create the production image
FROM node:18-slim AS runner

# Set environment variable for production
ENV NODE_ENV production

# Set the working directory in the production container
WORKDIR /app

# Copy only the build output and necessary files from the builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose port 3000 for the Next.js app
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]