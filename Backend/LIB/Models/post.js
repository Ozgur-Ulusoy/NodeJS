const mongoose = require('mongoose');

const PostSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId, //! ID is automatically created by MongoDB - ID OF POST
    title: {
        type: String,
        required: true,
        },  
    // content: { //! CONTENT OF POST
    //     type: String,
    //     minlength: 10,
    //     required: true,
    //     },  
    ownerId : { //! ID OF USER WHO MADE THE POST
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        },
    ownerName : { //! NAME OF USER WHO MADE THE POST
        type: String,
        required: true,
        },
    time : { //! TIME OF POST CREATION
        type: Date,
        default: Date.now,
        },
    comments : [], //! COMMENTS OF POST
    interactions: { //! INTERACTIONS OF POST
        likes: { //! LIKES OF POST
            type: Array,
            default: [],
            },
        dislikes: { //! DISLIKES OF POST
            type: Array,
            default: [],
            },
        }
});

const Post = mongoose.model('Post', PostSchema);
module.exports = Post;