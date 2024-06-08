# Use the official image as a parent image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy the local files to the container's working directory
COPY . .

# Install dependencies
RUN npm install

# Build the application
RUN npm run build

# Expose the port the app runs on
EXPOSE 80

# Run the application
CMD ["npm", "start"]