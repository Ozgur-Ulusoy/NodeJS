const mongoose = require('mongoose');

const CommentSchema = mongoose.Schema({
    content: { //! CONTENT OF COMMENT - ITS USER'S COMMENT
        type: String,
        required: true,
        },
    ownerId : { //! ID OF USER WHO MADE THE COMMENT 
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        },
    time : { //! TIME OF COMMENT
        type: Date,
        default: Date.now,
        },
    interactions: {
        likes: { //! LIKES OF COMMENT
            type: Array,
            default: [],
            },
        dislikes: { //! DISLIKES OF COMMENT
            type: Array,
            default: [],
            },
        },
    comments: { //! REPLIES OF COMMENT
        type: Array,
        default: [],
        // minimalize : true,
        // $unset: { $cond: { if: { $eq: [ "$replies", null ] }, then: "$$PRUNE", else: "$$KEEP" }
        // }
    },
});

const Comment = mongoose.model('Comment', CommentSchema);
module.exports = Comment;