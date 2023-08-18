const http = require('http');
const app = require('./LIB/app');
const port = process.env.PORT || 3000;

// const dbClient = require('./LIB/db');

//! SERVER CONNECTION
const server = http.createServer(app);
server.listen(port, async () => {
    // await dbClient.connect(); //! WHEN SERVER IS STARTED, CONNECT TO DB FIRST
    console.log('Connected successfully to server');
    console.log(`Server is running on port ${port}`);
});

module.exports = server;