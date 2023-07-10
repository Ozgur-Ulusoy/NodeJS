const mongoose = require('mongoose');

const UserSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId, //! ID is automatically created by MongoDB - ID OF USER
    username: { //! USERNAME OF USER
        type: String,
        unique: true,
        required: true,
        },
    password: { //! PASSWORD OF USER
        type: String,
        minlength: 6,
        required: true,
        },
}); 

const User = mongoose.model('User', UserSchema);
module.exports = User;