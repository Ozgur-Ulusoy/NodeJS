const express = require('express');
const router = express.Router();

const {createComment, replyComment, getComment, getReply, interactWithComment, interactWithReply} = require('../Controllers/comment');

//! Create a comment to post
router.post('/create', async (req, res, next) => {
    console.log('an attempt to create a comment was made');
    var result = await createComment(req.headers.postid, req.body.content, req.headers.ownerid, req.headers.token);
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

//! Get Comment by post id - Limit to x
router.get('/getComment', async (req, res, next) => {
    console.log('an attempt to get a comment was made with limit');
    // // const {postId, limit} = req.params;
    // const postid = req.headers.postid;
    // const limit = req.headers.limit;

    var result = await getComment(req.headers.postid, req.headers.limit);
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

//! Interact with comment
router.post('/interact', async (req, res, next) => {
    console.log('an attempt to interact with a comment was made');
    var result = await interactWithComment(req.headers.postid, req.headers.commentid, req.headers.userid, req.headers.type,  req.headers.token);

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

module.exports = router;