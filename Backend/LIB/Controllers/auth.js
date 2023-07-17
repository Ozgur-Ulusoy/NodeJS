const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
// const db = require('../db.js');
const dbClient = require('../db.js');
const User = require('../models/user.js');

const Login = async (username, password) => {
        console.log(username + ' ' + password);
        
        var encryptedPassword = await bcrypt.hash(password, 10); // create hash password
        
        const oldUser = await dbClient.db('DB').collection('Users').findOne({username: username}); // find user by username
        
        console.log(oldUser);
        if (!oldUser) { // if user not found create new user
            // create
            const newUser = new User({
                username: username,
                password: encryptedPassword,
                token: null,
            });

            const user = await dbClient.db('DB').collection('Users').insertOne(newUser);

            const token = jwt.sign({ user_id: user._id, username }, process.env.TOKEN_KEY, {
                expiresIn: "24h",
            });

            console.log(token);
            newUser.token = token;
            dbClient.db('DB').collection('Users').updateOne({_id: user._id}, {$set: {token: token}});
            
            return {success: true, user: newUser, message: 'User created successfully'};
        }
    
        const isPasswordCorrect = await bcrypt.compare(password, oldUser.password);
        console.log(isPasswordCorrect);
        
        if (isPasswordCorrect) {
            const token = jwt.sign({ user_id: oldUser._id, username }, process.env.TOKEN_KEY, {
                expiresIn: "24h",
            });
            // update token in db
            dbClient.db('DB').collection('Users').updateOne({_id: oldUser._id}, {$set: {token: token}});
            oldUser.token = token;
            return {success: true, user: oldUser, message: 'User logged in successfully'};
        }
    
        else{
            return {success: false, message: 'Invalid username or password'};
        }
}

const Logout = async (token) => {
    try {
        const decoded = jwt.verify(token, process.env.TOKEN_KEY);
        const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(decoded.user_id), username: decoded.username});
        if(user.token === token) {
            await dbClient.db('DB').collection('Users').updateOne({_id: user._id}, {$set: {token: null}});
            return {success: true, message: 'User logged out successfully'};
        }
        else {
            return {success: false, message: 'Invalid token'};
        }
    } catch (error) {
        return {success: false, message: 'Invalid token'};
    }
}

const CheckSession = async (token) => {
    try {
        const decoded = jwt.verify(token, process.env.TOKEN_KEY);
        const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(decoded.user_id), username: decoded.username});
        if(user.token === token) {
            return {success: true, user: user, message: 'User logged in successfully'};
        }
        else {
            return {success: false, message: 'Invalid token'};
        }
    } catch (error) {
        return {success: false, message: 'Invalid token'};
    }
}

// // create controller for signup
// exports.signup = (req, res, next) => {
//     const {username, password} = req.body;
    
// }
module.exports = {
    Login,
    Logout,
    CheckSession,
}
