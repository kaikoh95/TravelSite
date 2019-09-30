# Travel-Site
Complete travel query web client and server created using node.js and vue.js for the front and back ends of this web application.

Currently only supports Desktop browsers; will be adding support for Mobile browsers in the future.

I have used Docker to run the backend server and deployed the web app on netlify - https://travel-review.netlify.com 

This is the repo used for automatically deploying the web app - https://github.com/kaikoh95/travel-reviewer

# Running Locally
1. Set up the database
  - Run 'docker-compose up -d' in db folder to set up the database in Docker container.
  - Initialise and populate db using the script provided.
2. Set up the server
  - Create a .env file in the server folder, according to the instructions provided.
  - Run 'docker-compose up -d' in server folder.
3. Run the client
  - Run 'npm install'
  - Run 'npm dev' or 'npm build'
  - Access the client at localhost:8080
