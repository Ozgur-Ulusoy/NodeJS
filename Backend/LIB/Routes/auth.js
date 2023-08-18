const express = require('express');
const router = express.Router();
const {Login, Logout, CheckSession, SendVerifyEmail, VerifyEmail, SendResetPasswordEmail, ResetPassword, CheckEmail} = require('../Controllers/auth');

router.post('/login', async (req, res, next) => { // /:username/:password

    var result = await Login(req.headers.username,req.headers.email, req.headers.password);
    if(result.success) {
        res.status(200).json({
            message: result['message'],
            user: result['user'],
        });
    }
    else {
        res.status(500).json({
            message: result['message'],
        });
    }
});

router.post('/logout', async (req, res, next) => {
    const result = await Logout(req.headers.token);
    if(result.success) {
        res.status(200).json({
            message: result['message'],
        });
    }
    else {
        res.status(500).json({
            message: result['message'],
        });
    }
});

router.get('/checkSession', async (req, res, next) => {
    var result = await CheckSession(req.headers.token);
    if(result.success) {
        res.status(200).json({
            success: result['success'],
            message: result['message'],
            // user: result['user'],
        });
    }
    else {
        res.status(500).json({
            message: result['message'],
        });
    }
});

router.post('/sendVerifyEmail', async (req, res, next) => {

    var result = 
    (async () => await SendVerifyEmail(req.headers.email, req.headers.username))()
    // await VerifyEmail(email, username);

    // console.log(result);
    if(result) {
        res.status(200).json({
            message: 'Email sent',
        });
    }
    else {
        res.status(500).json({
            message: 'Error',
        });
    }
});

router.get('/verifyEmail/:token', async (req, res, next) => {
    var result = await VerifyEmail(req.params.token);
    if(result.success) {
        // res.status(200).json({
        //     success: result['success'],
        //     message: result['message'],
        // });

        // return html page with success message
        res.send('<h1>Success</h1><p>Your email has been verified</p>')
    }
    else {
        // res.status(500).json({
        //     message: result['message'],
        // });
        res.send('<h1>Error</h1><p>Your email could not be verified</p>')
    }
});

router.post('/sendResetPasswordEmail', async (req, res, next) => {
    var validEmail = await CheckEmail(req.headers.email);
    console.log(validEmail);
    if(!validEmail) {
        console.log('Email not registered');
        return res.status(200).json({
            success: false,
            message: 'Email not registered',
        });
        
    }

    var result =  (async () => await SendResetPasswordEmail(req.headers.email, req.headers.password))();
    if(result){
        res.status(200).json({
            success : true,
            message: 'Email sent',
        });
    }
    else {
        res.status(500).json({
            success : false,
            message: 'Error',
        });
    }
});

router.get('/resetPassword/:token', async (req, res, next) => {

    var result = await ResetPassword(req.params.token);
    if(result) {
        // res.status(200).json({
        //     message: 'Password reset successfully',
        // });
        res.send('<h1>Success</h1><p>Your password has been reset</p>')
    }
    else {
        // res.status(500).json({
        //     message: 'Error',
        // });
        res.send('<h1>Error</h1><p>Your password could not be reset</p>')
    }
});


module.exports = router;