const mongoose = require('mongoose');
const Post = require('../Models/post');
const dbClient = require('../db.js');
const Comment = require('../Models/comment');


const createPost = async (title, content, ownerId, token) => {

    if(!title || !content || !ownerId || !token) {
        console.log('missing fields');
        return {
            success: false,
            message: 'Missing fields',
        };
    }

    // find user by ownerid
    const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(ownerId), token: token});

    if(!user) {
        console.log('no user found');
        return {
            success: false,
            message: 'Invalid token',
        };
    }
    
    const newPost = new Post({
        title: title,
        ownerId: new mongoose.Types.ObjectId(ownerId),
        ownerName: user.username,
    });

    const newComment = new Comment({
        content: content,
        ownerId: new mongoose.Types.ObjectId(ownerId),
        ownerName: user.username,
    });
    newPost.comments.push(newComment);

    

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

const interactWithPost = async (postId, userId, interaction, token) => {

    if(!postId || !userId || !interaction || !token) {
        console.log('missing fields');
        return {
            success: false,
            message: 'Missing fields',
        };
    }

    // find user by ownerid
    const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(userId), token: token});
    if(!user) {
        console.log('no user found');
        return {
            success: false,
            message: 'Invalid token',
        };
    }

    var post = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId)});
    var interactions = post['interactions'];

    var likedArr = interactions['likes'] ;
    var dislikedArr = interactions['dislikes'] ;

    if(interaction === 'like') {
        var hasLiked = likedArr.includes(userId);
        var hasDisliked = dislikedArr.includes(userId);

        if(hasLiked) {
            // remove like
            likedArr.splice(likedArr.indexOf(userId), 1);
        }
        else {
            // add like
            likedArr.push(userId);
            // remove dislike
            if(hasDisliked) {
                dislikedArr.splice(dislikedArr.indexOf(userId), 1);
            }
        }
    }
    else {
        var hasDisliked = dislikedArr.includes(userId);
        var hasLiked = likedArr.includes(userId);

        if(hasDisliked) {
            // remove dislike
            dislikedArr.splice(dislikedArr.indexOf(userId), 1);
        }
        else {
            // add dislike
            dislikedArr.push(userId);
            // remove like
            if(hasLiked) {
                likedArr.splice(likedArr.indexOf(userId), 1);
            }
        }
    }

    var newInteractions = {
        likes: likedArr,
        dislikes: dislikedArr,
    };

    // update post
    var res = await dbClient.db('DB').collection('Posts').updateOne({_id: new mongoose.Types.ObjectId(postId)}, {$set: {interactions: newInteractions}}).then((val) => {
        return val.acknowledged;
    });

    return {
        success: res,
        // interactionType: interactionType,
        interactions: newInteractions,
    };
};

const getPostCount = async () => {
    const count = await dbClient.db('DB').collection('Posts').countDocuments();
    return count;
};

const getPostByPage = async (page = 0, limit = 25) => {
    // convert limit to int

    limit = parseInt(limit);
    page = parseInt(page);

    skip = (page) * limit

    const posts = await dbClient.db('DB').collection('Posts').find().skip(skip).limit(limit).toArray();
    console.log(posts);
    return posts;
};

module.exports = {
    createPost,
    getPostById,
    getRandomPostByCount,
    getPostByTitle,
    interactWithPost,
    getPostCount,
    getPostByPage,
};