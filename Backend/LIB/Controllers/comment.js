const mongoose = require('mongoose');
const Comment = require('../Models/comment');
const dbClient = require('../db.js');

const createComment = async (postId, content, ownerId, token) => {

    if(!postId || !content || !ownerId || !token) {
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

    const newComment = new Comment({
        content: content,
        ownerId: new mongoose.Types.ObjectId(ownerId),
        ownerName: user.username,
    });

    // add comment to post
    var res = await dbClient.db('DB').collection('Posts').updateOne({_id: new mongoose.Types.ObjectId(postId)}, {$addToSet: {comments: newComment}}).then((val) => {
        return val.acknowledged;
    }); // is added to db;
    return {
        success: res,
        comment: newComment,
    }; 
}

// const replyComment = async (postId, commentId, content, ownerId, token) => {

//     if(!postId || !commentId || !content || !ownerId || !token) {   
//         console.log('missing fields');
//         return {
//             success: false,
//             message: 'Missing fields',
//         };
//     }

//     // find user by ownerid
//     const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(ownerId), token: token});
//     if(!user) {
//         console.log('no user found');
//         return {
//             success: false,
//             message: 'Invalid token',
//         };
//     }

//     const newComment = new Comment({
//         content: content,
//         ownerId: new mongoose.Types.ObjectId(ownerId),
//         comments: null,
//     });

//     // add comment to post
//     var res = await dbClient.db('DB').collection('Posts').updateOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId)}, {$addToSet: {'comments.$.comments': newComment}}).then((val) => {
//         return val.acknowledged;
//     }); // is added to db;
//     return {
//         success: res,
//         comment: newComment,
//     };
// }

const getComment = async (postId, limit = 5) => {
    // convert limit to int
    limit = parseInt(limit);
    
    // get comments by post id
    // const comments = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId)}, {projection: {_id: 0, comments: {$slice: limit}}}).then((val) => {
        // get all comments
    const comments = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId)}, {projection: {_id: 0, comments: 1}}).then((val) => {
    // get all comments length
        var comms = val.comments.slice(0, limit);
        return {
            comments: comms,
            totalLength: val.comments.length,
        };
    });
    // console.log(comments);
    return comments;
}

// const getReply = async (postId, commentId, limit = 5) => {
//     // convert limit to int
//     limit = parseInt(limit);

//     // get replies by post id and comment id
//     const replies = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId)}, {projection: {_id: 0, 'comments.$': 1}}).then((val) => {
//         // get all replies
//         var totalLength = val.comments[0].comments.length;
//         var reply = val.comments[0].comments.slice(0, limit);
//         return {
//             comments: reply,
//             totalLength: totalLength,
//         };
//     });

//     return replies;
// }

const interactWithComment = async (postId, commentId, userId, interaction, token) => {

    if(!postId || !commentId || !userId || !interaction || !token) {
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

    // get comment by post id and comment id
    var comment = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId)}, {projection: {_id: 0, 'comments.$': 1}});
    comment = comment.comments[0];
    var interactions = comment.interactions;

    var likedArr = interactions['likes'];
    var dislikedArr = interactions['dislikes'];

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

    // update comment
    var res = await dbClient.db('DB').collection('Posts').updateOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId)}, {$set: {'comments.$.interactions': newInteractions}}).then((val) => {
        return val.acknowledged;
    }
);

    return {
        success: res,
        // interactionType: interactionType,
        interactions: newInteractions,
    };

}

// const interactWithReply = async (postId, commentId, replyId, userId, interaction, token) => {
    
//     if(!postId || !commentId || !replyId || !userId || !interaction || !token) {
//         console.log('missing fields');
//         return {
//             success: false,
//             message: 'Missing fields',
//         };
//     }

//     // find user by ownerid
//     const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(userId), token: token});
//     if(!user) {
//         console.log('no user found');
//         return {
//             success: false,
//             message: 'Invalid token',
//         };
//     }

//     // get the object of the reply - reply is under replies array in the comment and has the same id as the replyId
//     var reply = await dbClient.db('DB').collection('Posts').findOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId), 'comments.comments._id': new mongoose.Types.ObjectId(replyId)}, {projection: {_id: 0, 'comments.$': 1}}).then((val) => {
//         return val.comments[0].comments.filter((reply) => {
//             return reply._id.toString() === replyId.toString();
//         })[0];
//     });

//     var interactions = reply.interactions;

//     var likedArr = interactions['likes'];
//     var dislikedArr = interactions['dislikes'];

//     if(interaction === 'like') {
//         var hasLiked = likedArr.includes(userId);
//         var hasDisliked = dislikedArr.includes(userId);

//         if(hasLiked) {
//             // remove like
//             likedArr.splice(likedArr.indexOf(userId), 1);
//         }
//         else {
//             // add like
//             likedArr.push(userId);
//             // remove dislike
//             if(hasDisliked) {
//                 dislikedArr.splice(dislikedArr.indexOf(userId), 1);
//             }
//         }
//     }
//     else {
//         var hasDisliked = dislikedArr.includes(userId);
//         var hasLiked = likedArr.includes(userId);

//         if(hasDisliked) {
//             // remove dislike
//             dislikedArr.splice(dislikedArr.indexOf(userId), 1);
//         }
//         else {
//             // add dislike
//             dislikedArr.push(userId);
//             // remove like
//             if(hasLiked) {
//                 likedArr.splice(likedArr.indexOf(userId), 1);
//             }
//         }
//     }

//     var newInteractions = {
//         likes: likedArr,
//         dislikes: dislikedArr,
//     };
    

//     // var hasInteracted = interactionArr.includes(userId);

//     // var interactionType = hasInteracted ? 'remove' : 'add';

//     // if (hasInteracted) {
//     //     // remove interaction
//     //     interactionArr.splice(interactionArr.indexOf(userId), 1);
//     // }
//     // else {
//     //     // add interaction
//     //     interactionArr.push(userId);
//     //     // pop from the other array if it exists
//     // }

//     // var newInteractions;
//     // if(interaction.toString() === 'like') {
//     //     newInteractions = {
//     //         likes: interactionArr,
//     //         dislikes: interactions['dislikes'],
//     //     };
//     // }
//     // else {
//     //     newInteractions = {
//     //         likes: interactions['likes'],
//     //         dislikes: interactionArr,
//     //     };
//     // }

//     // console.log(newInteractions);

//     // update reply
//     var res = await dbClient.db('DB').collection('Posts').updateOne({_id: new mongoose.Types.ObjectId(postId), 'comments._id': new mongoose.Types.ObjectId(commentId), 'comments.comments._id': new mongoose.Types.ObjectId(replyId)}, {$set: {'comments.$.comments.$[i].interactions': newInteractions}}, {arrayFilters: [{'i._id': new mongoose.Types.ObjectId(replyId)}]}).then((val) => {
//         return val.acknowledged;
//     });

//     return {
//         success: res,
//         // interactionType: interactionType,
//         interactions: newInteractions,
//     };
// }

module.exports = {
    createComment,
    // replyComment,
    getComment,
    // getReply,
    interactWithComment,
    // interactWithReply,
};