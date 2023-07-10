const mongoose = require('mongoose');
const Post = require('../Models/post');
const dbClient = require('../db.js');

const createPost = async (title, content, ownerId) => {
    const newPost = new Post({
        title: title,
        content: content,
        ownerId: new mongoose.Types.ObjectId(ownerId),
    });

    var res = (await dbClient.db('DB').collection('Posts').insertOne(newPost)).acknowledged // is added to db
    // console.log(res);
    return {
        success: res,
        post: newPost,
    }; 
};

const getPostById = async (id) => {
    // const post = await Post.findById(id);
    const post = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(id)});
    return post;
};

const getRandomPostByCount = async (count) => {
    const posts = await dbClient.db('DB').collection('Posts').aggregate([{$sample: {size: parseInt(count)}}]).toArray();
    return posts;
};

const getPostByTitle = async (title, limit = 5) => {
    // convert limit to int
    limit = parseInt(limit);
    // get post by title starting with title
    // max 10 posts
    // const posts = await dbClient.db('DB').collection('Posts').find({title: {$regex: '^' + title}}).toArray();
    const posts = await dbClient.db('DB').collection('Posts').find({title: {$regex: '^' + title}}).limit(limit).toArray();
    return posts;
}

module.exports = {
    createPost,
    getPostById,
    getRandomPostByCount,
    getPostByTitle,
};