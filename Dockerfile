# bashCopy code
# Use the official Node.js image as the base image
# FROM node:20

# WORKDIR /web

# COPY . /web
# RUN npm -y -g install serve

# ENV PORT 8080
# EXPOSE 8080

# Install the application dependencies
# RUN npm install

# Define the entry point for the container
# CMD ["npm", "start"]
# CMD ["serve", "web"]
# Use an official nginx image as a parent image
FROM nginx:stable-alpine

# Copy the current directory contents into the container at /usr/share/nginx/html
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Use the default command for the nginx:stable-alpine image: "nginx -g 'daemon off;'"
