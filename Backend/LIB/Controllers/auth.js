const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const nodemailer = require('nodemailer');


// const db = require('../db.js');
const dbClient = require('../db.js');

const User = require('../models/user.js');

const transporter = nodemailer.createTransport({
    service: 'gmail',
    host: "smtp.gmail.com",
    secure: false,
    port: 587,
    auth: {
        user: process.env.EMAIL_USERNAME,
        pass: process.env.EMAIL_PASSWORD,
    }
});

transporter.verify(function (error, success) {

    if (error) console.log(error);
    else
        console.log('Bağlantı başarıyla sağlandı');
  
  });



const Login = async (username,email, password) => {
        console.log(username + ' ' + password);
        
        var encryptedPassword = await bcrypt.hash(password, 10); // create hash password
        
        const oldUser = await dbClient.db('DB').collection('Users').findOne({username: username, email: email}); // find user by username
        
        console.log(oldUser);
        if (!oldUser) { // if user not found create new user
            // create
            const newUser = new User({
                username: username,
                email: email,
                password: encryptedPassword,
                token: null,
                isVerified: false,
            });

            const user = await dbClient.db('DB').collection('Users').insertOne(newUser);

            const token = jwt.sign({ user_id: user._id, username }, process.env.TOKEN_KEY, {
                expiresIn: "24h",
            });

            //! if user will not be verified after 1 hours, delete user from db
            setTimeout(async () => {
                console.log('do mission');
                console.log(await dbClient.db('DB').collection('Users').findOne({_id: user._id , isVerified: false}));
                await dbClient.db('DB').collection('Users').deleteOne({_id: user._id , isVerified: false});
        }, 1); 

            console.log(token);
            newUser.token = token;
            dbClient.db('DB').collection('Users').updateOne({_id: user._id}, {$set: {token: token}});
            
            return {success: true, user: newUser, message: 'User created successfully'};
        }

        const isVerified = oldUser.isVerified;
        if(!isVerified) {
            return {success: false, message: 'User not verified'};
        }
    
        const isPasswordCorrect = await bcrypt.compare(password, oldUser.password);
        console.log(isPasswordCorrect);
        
        if (isPasswordCorrect) {
            const token = jwt.sign({ user_id: oldUser._id, username, email: email }, process.env.TOKEN_KEY, {
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
        const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(decoded.user_id), username: decoded.username , email: decoded.email});
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
        const user = await dbClient.db('DB').collection('Users').findOne({_id: new mongoose.Types.ObjectId(decoded.user_id), username: decoded.username, email: decoded.email});
        if(user.token === token) {
            return {success: true, message: 'User logged in successfully'};
        }
        else {
            return {success: false, message: 'Invalid token'};
        }
    } catch (error) {
        return {success: false, message: 'Invalid token'};
    }
}

const SendVerifyEmail = async (email, username) => {
    const token = jwt.sign({
        data: {
            email: email,
            username: username,
        }}, process.env.TOKEN_KEY, { expiresIn: '10m' }  
    );    
    
    const mailConfigurations = {
    from: process.env.EMAIL_USERNAME,
    to: email,
    // Subject of Email
    subject: 'WorldFlow Email Verification',
    // This would be the text of email body
    text: `Hello! Please follow the given link to verify your email http://localhost:3000/api/auth/verifyEmail/${token} Thanks`
    };

    // const sendEmail = async () => {
         return await transporter.sendMail(mailConfigurations, function (error, info) {
            // wait for response and return info if successful or error if unsuccessful
            if (error) {
                console.log(error);
                res = {success: false, message: 'Email not sent'};
            } else {
                console.log('Email sent: ' + info.response);
                res = {success: true, message: 'Email sent'};
                return info.response;
            }
        });
    // }
}

const VerifyEmail = async (token) => {
    try {
        const decoded = jwt.verify(token, process.env.TOKEN_KEY);
        const user = await dbClient.db('DB').collection('Users').findOne({email: decoded.data.email, username: decoded.data.username});
        if(user) {
            await dbClient.db('DB').collection('Users').updateOne({_id: user._id}, {$set: {isVerified: true}});
            return {success: true, message: 'User verified successfully'};
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
    SendVerifyEmail,
    VerifyEmail,
}
