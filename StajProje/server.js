const http = require('http');
const app = require('./LIB/app');
const port = process.env.PORT || 3000;

const dbClient = require('./LIB/db');

//! SERVER CONNECTION
const server = http.createServer(app);
server.listen(port, async () => {
    await dbClient.connect(); //! WHEN SERVER IS STARTED, CONNECT TO DB FIRST
    console.log('Connected successfully to server');
    
    //! // save image to db
    // const fs = require('fs');
    // const path = require('path'); 
    // const imgPath = path.join(__dirname, 'images', 'test.jpg');
    // const img = fs.readFileSync(imgPath);
    // const encodedImg = img.toString('base64');

    // const imgDoc = {
    //     name: 'test image',
    //     img: Buffer.from(encodedImg, 'base64'),
    // };

    // const dbImages = client.db('DB').collection('Images');
    // await dbImages.insertOne(imgDoc);

    // // get image from db
    // const imgFromDb = await dbImages.findOne({name: 'test image'});
    // const imgBuffer = imgFromDb.img.buffer;
    // const imgBase64 = imgBuffer.toString('base64');
    
    // console.log(imgBase64);


    console.log(`Server is running on port ${port}`);
});

// global.dbClient = dbClient;
// global.server = server;

// exports = {server, dbClient};