# Lightweight Node.js base image (Alpine) for smaller and faster container builds.
FROM node:20-alpine

# Optional metadata label useful for container registries and governance.
LABEL org.opencontainers.image.title="mini-idp-app"

# Docker Hub naming convention placeholder:
# <dockerhub-username>/mini-idp-app:<tag>
# Example: yourusername/mini-idp-app:1.0.0

# Set default runtime environment and default application port.
# The app code still resolves port using process.env.PORT || 3000.
ENV NODE_ENV=production
ENV PORT=3000

# Set working directory inside the container.
WORKDIR /usr/src/app

# Copy package descriptor files first to optimize Docker layer cache reuse.
COPY package*.json ./

# Install only production dependencies for a lean image.
RUN npm ci --omit=dev

# Copy full application source after dependency installation.
COPY . .

# Expose the application port for local run and EC2 host port mapping.
EXPOSE 3000

# Start the Express application using package.json start script.
CMD ["npm", "start"]
