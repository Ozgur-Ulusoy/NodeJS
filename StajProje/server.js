const http = require('http');
const app = require('./LIB/app');
const port = process.env.PORT || 3000;

const dbClient = require('./LIB/db');

//! SERVER CONNECTION
const server = http.createServer(app);
server.listen(port, async () => {
    await dbClient.connect(); //! WHEN SERVER IS STARTED, CONNECT TO DB FIRST
    console.log('Connected successfully to server');

    const dbUsers = dbClient.db('DB').collection('Users');    

    // find the first document
    const user = await dbUsers.findOne();
    console.log(user._id.toString());

    //!
    // const dbPosts = client.db('DB').collection('Posts');

    // const postModule = require('./LIB/Models/post');
    // const userModule = require('./LIB/Models/user');
    // const commentModule = require('./LIB/Models/comment');

    // const user1 = new userModule({
    //     username: 'test user 1',
    //     password: 'test1236',
    // });

    // const user2 = new userModule({
    //     username: 'test user 2',
    //     password: 'test1236',
    // });

    // await dbUsers.insertOne(user1);
    // await dbUsers.insertOne(user2);

    // const comment1 = new commentModule({
    //     content: 'test comment 1',
    //     ownerId: user1._id,
    // });

    // const comment2 = new commentModule({
    //     content: 'test comment 2',
    //     ownerId: user2._id,
    // });

    // const post = new postModule({
    //     title: 'test article',
    //     content: 'test content',
    // });

    // await dbPosts.insertOne(post);

    // await dbPosts.updateOne({_id: post._id}, {$addToSet: {comments: comment1}});
    // await dbPosts.updateOne({_id: post._id}, {$addToSet: {comments: comment2}});

    // const comment3 = new commentModule({
    //     content: 'test comment 3',
    //     ownerId: user1._id,
    // });

    // await dbPosts.updateOne({_id: post._id}, {$addToSet: {comments: comment3}});
    // await dbPosts.updateOne({_id: post._id}, {$addToSet: {comments: comment1}});
    
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