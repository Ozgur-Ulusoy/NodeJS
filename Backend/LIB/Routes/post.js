const express = require('express');
const router = express.Router();

const {createPost, getPostById, getRandomPostByCount, getPostByTitle, interactWithPost} = require('../Controllers/post');

//! Create a post
router.post('/create', async (req, res, next) => {
    console.log('an attempt to create a post was made');
    const title = req.headers.title;
    const content = req.headers.content;
    const ownerid = req.headers.ownerid;
    const token = req.headers.token;
    console.log(title, content, ownerid, token);
    var result = await createPost(title, content, ownerid, token);
    console.log(result);
    if(result.success) {
        res.status(200).json({
            message: 'Post created successfully',
            post: result['post'],
        });
    }
    else {
        res.status(500).json({
            message: 'Post creation failed',
        });
    }
});

//! Get Post by Id
router.get('/getPostById', async (req, res, next) => {
    console.log('an attempt to get a post by id was made');
    // const {id} = req.params;
    const postid = req.headers.postid;
    var result = await getPostById(postid);
    if (result) {
        res.status(200).json({
            message: 'Post retrieved successfully',
            post: result,
        });
    }
    else {
        res.status(500).json({
            message: 'Post retrieval failed',
        });
    }


});

//! Get Random Post by Count
router.get('/getRandomPostByCount', async (req, res, next) => {
    console.log('an attempt to get a random post by count was made');
    // const {count} = req.params;
    const count = req.headers.count;
    var result = await getRandomPostByCount(count);
    if (result) {
        res.status(200).json({
            message: 'Post retrieved successfully',
            posts: result,
        });
    }
    else {
        res.status(500).json({
            message: 'Post retrieval failed',
        });
    }
});

//! Get Post by Title and Limit (default limit is 5)
router.get('/getPostByTitle', async (req, res, next) => {
    console.log('an attempt to get a post by title was made');
    // const {title, limit} = req.params;
    const title = req.headers.title;
    const limit = req.headers.limit;

    var result = await getPostByTitle(title, limit);
    if (result) {
        res.status(200).json({
            message: 'Post retrieved successfully',
            posts: result,
        });
    }
    else {
        res.status(500).json({
            message: 'Post retrieval failed',
        });
}});

//! Post interaction to post (like, dislike)
router.post('/interaction', async (req, res, next) => {
    console.log('an attempt to interact with a post was made');
    // const {postId, ownerId, type} = req.params;
    const postid = req.headers.postid;
    const ownerid = req.headers.ownerid;
    const type = req.headers.type;
    const token = req.headers.token;

    var result = await interactWithPost(postid, ownerid, type, token);
    console.log(result);
    if (result.success) {
        res.status(200).json({
            message: 'Post interaction successful',
            interactionType: result.interactionType,
            interactions: result.interactions,
        });
    }
    else {
        res.status(500).json({
            message: 'Post interaction failed',
        });
    }
});

module.exports = router;