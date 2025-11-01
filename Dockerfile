# Use an official lightweight Node.js image.
FROM node:22-alpine

# Set the working directory in the container.
WORKDIR /usr/src/app

# Install pnpm globally
RUN npm install -g pnpm

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies.
RUN pnpm install --frozen-lockfile

# Copy the rest of the source code.
COPY . .

# Build the project (assuming tsc is configured to output to the 'dist' folder)
RUN pnpm run build

# Expose the port (make sure this matches your config; here we assume 3000)
EXPOSE 3001

# Start the application.
CMD ["pnpm", "start"]