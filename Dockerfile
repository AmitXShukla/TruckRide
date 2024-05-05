# bashCopy code
# Use the official Node.js image as the base image
FROM node:lts-alpine

RUN npm -y -g install serve
# Set the working directory in the container
WORKDIR /app/

# Copy the application files into the working directory
COPY . .

EXPOSE 3000
# Install the application dependencies
# RUN npm install

# Define the entry point for the container
CMD ["serve", "web"]