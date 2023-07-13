const express = require('express');
const router = express.Router();

const {createComment, replyComment, getComment, getReply, interactWithComment, interactWithReply} = require('../Controllers/comment');

//! Create a comment to post
router.post('/create/:postId/:content/:ownerId', async (req, res, next) => {
    console.log('an attempt to create a comment was made');
    const {postId, content, ownerId} = req.params;
    var result = await createComment(postId, content, ownerId);
    if(result.success) {
        res.status(200).json({
            message: 'Comment created successfully',
            comment: result['comment'],
        });
    }
    else {
        res.status(500).json({
            message: 'Comment creation failed',
        });
    }
});

//! Reply to a comment
router.post('/reply/:postId/:commentId/:content/:ownerId', async (req, res, next) => {
    console.log('an attempt to reply to a comment was made');
    const {postId, commentId, content, ownerId} = req.params;
    var result = await replyComment(postId, commentId, content, ownerId);
    if(result.success) {
        res.status(200).json({
            message: 'Comment replied successfully',
            comment: result['comment'],
        });
    }
    else {
        res.status(500).json({
            message: 'Comment reply failed',
        });
    }
});

//! Get Comment by post id - Limit to x
router.get('/getComment/:postId/:limit', async (req, res, next) => {
    console.log('an attempt to get a comment was made with limit');
    const {postId, limit} = req.params;
    var result = await getComment(postId, limit);
    if(result) {
        res.status(200).json({
            message: 'Comment retrieved successfully',
            totalLength : result['totalLength'],
            comments: result['comments'],
        });
    }
    else {
        res.status(500).json({
            message: 'Comment retrieval failed',
        });
    }
});

//! Get Reply by comment id - Limit to x
router.get('/getReply/:postId/:commentId/:limit', async (req, res, next) => {
    console.log('an attempt to get a reply was made with limit');
    const {postId, commentId, limit} = req.params;
    var result = await getReply(postId, commentId, limit);
    if(result) {
        res.status(200).json({
            message: 'Reply retrieved successfully',
            totalLength : result['totalLength'],
            replies: result['replies'],
        });
    }
    else {
        res.status(500).json({
            message: 'Reply retrieval failed',
        });
    }
});

//! Interact with comment
router.post('/interact/:postId/:commentId/:userId/:type', async (req, res, next) => {
    console.log('an attempt to interact with a comment was made');
    const {postId, commentId, userId, type} = req.params;
    var result = await interactWithComment(postId, commentId, userId, type);

    if(result.success) {
        res.status(200).json({
            message: 'Comment interaction successful',
            interactionType: result.interactionType,
            interactions: result.interactions,
        });
    }
    else {
        res.status(500).json({
            message: 'Comment interaction failed',
        });
    }
});

//! Interact with reply
router.post('/interact/:postId/:commentId/:replyId/:userId/:type', async (req, res, next) => {
    console.log('an attempt to interact with a reply was made');
    const {postId, commentId, replyId, userId, type} = req.params;
    var result = await interactWithReply(postId, commentId, replyId, userId, type);

    if(result.success) {
        res.status(200).json({
            message: 'Reply interaction successful',
            interactionType: result.interactionType,
            interactions: result.interactions,
        });
    }
    else {
        res.status(500).json({
            message: 'Reply interaction failed',
        });
    }
});

module.exports = router;