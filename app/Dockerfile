# Use a slim official Node.js runtime image.
FROM node:20-alpine

# Set a working directory inside the container filesystem.
WORKDIR /usr/src/app

# Copy dependency metadata first to optimize Docker layer caching.
COPY package.json ./

# Install production dependencies only for a lean image.
RUN npm install --omit=dev

# Copy application source code into the image.
COPY server.js ./

# Expose the app port used by the Express server.
EXPOSE 3000

# Start the application container process.
CMD ["npm", "start"]
