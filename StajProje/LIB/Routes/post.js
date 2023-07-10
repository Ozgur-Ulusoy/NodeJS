const express = require('express');
const router = express.Router();

const {createPost, getPostById, getRandomPostByCount, getPostByTitle} = require('../Controllers/post');

//! Create a post
router.post('/create/:title/:content/:ownerId', async (req, res, next) => {
    console.log('an attempt to create a post was made');
    const {title, content, ownerId} = req.params;
    var result = await createPost(title, content, ownerId);
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
router.get('/getPostById/:id', async (req, res, next) => {
    console.log('an attempt to get a post by id was made');
    const {id} = req.params;
    var result = await getPostById(id);
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
router.get('/getRandomPostByCount/:count', async (req, res, next) => {
    console.log('an attempt to get a random post by count was made');
    const {count} = req.params;
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
router.get('/getPostByTitle/:title/:limit', async (req, res, next) => {
    console.log('an attempt to get a post by title was made');
    const {title, limit} = req.params;
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

module.exports = router;