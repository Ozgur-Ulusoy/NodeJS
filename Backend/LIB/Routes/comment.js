const express = require('express');
const router = express.Router();

const {createComment, replyComment, getComment, getReply, interactWithComment, interactWithReply} = require('../Controllers/comment');

//! Create a comment to post
router.post('/create', async (req, res, next) => {
    console.log('an attempt to create a comment was made');
    const postid = req.headers.postid;
    const content = req.headers.content;
    const ownerid = req.headers.ownerid;
    const token = req.headers.token;

    var result = await createComment(postid, content, ownerid, token);
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
router.post('/reply', async (req, res, next) => {
    console.log('an attempt to reply to a comment was made');
    // const {postId, commentId, content, ownerId} = req.params;
    const postid = req.headers.postid;
    const commentid = req.headers.commentid;
    const content = req.headers.content;
    const ownerid = req.headers.ownerid;
    const token = req.headers.token;

    var result = await replyComment(postid, commentid, content, ownerid, token);
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
router.get('/getComment', async (req, res, next) => {
    console.log('an attempt to get a comment was made with limit');
    // const {postId, limit} = req.params;
    const postid = req.headers.postid;
    const limit = req.headers.limit;

    var result = await getComment(postid, limit);
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
router.get('/getReply', async (req, res, next) => {
    console.log('an attempt to get a reply was made with limit');
    // const {postId, commentId, limit} = req.params;
    const postid = req.headers.postid;
    const commentid = req.headers.commentid;
    const limit = req.headers.limit;

    var result = await getReply(postid, commentid, limit);
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
router.post('/interact', async (req, res, next) => {
    console.log('an attempt to interact with a comment was made');
    // const {postId, commentId, userId, type} = req.params;
    const postid = req.headers.postid;
    const commentid = req.headers.commentid;
    const userid = req.headers.userid;
    const type = req.headers.type;
    const token = req.headers.token;
    var result = await interactWithComment(postid, commentid, userid, type, token);

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
router.post('/interact', async (req, res, next) => {
    console.log('an attempt to interact with a reply was made');
    // const {postId, commentId, replyId, userId, type} = req.params;
    const postid  =  req.headers.postid;
    const commentid = req.headers.commentid;
    const replyid = req.headers.replyid;
    const userid = req.headers.userid;
    const type = req.headers.type;
    const token = req.headers.token;

    var result = await interactWithReply(postid, commentid, replyid, userid, type, token);

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