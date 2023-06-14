# Use a base image with Node.js pre-installed
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the application code to the working directory
COPY . .

# Expose the application port (change it if your application uses a different port)
EXPOSE 8080

# Define the command to run your application
CMD [ "node", "server.js" ]
