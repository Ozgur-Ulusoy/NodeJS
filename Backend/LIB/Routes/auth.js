const express = require('express');
const router = express.Router();
const {Login, Logout, CheckSession, SendVerifyEmail, VerifyEmail, SendResetPasswordEmail, ResetPassword, CheckEmail} = require('../Controllers/auth');

router.post('/login', async (req, res, next) => { // /:username/:password
    // const username = req.headers.username;
    // const email = req.headers.email;
    // const password = req.headers.password;

    var result = await Login(req.headers.username,req.headers.email, req.headers.password);
    console.log(result);
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
    // const token = req.headers.token;
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
    // const token = req.headers.token;
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
    // const email = req.headers.email;
    // const username = req.headers.username;

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
        res.status(200).json({
            success: result['success'],
            message: result['message'],
        });
    }
    else {
        res.status(500).json({
            message: result['message'],
        });
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
    // const token = req.params.token;

    var result = await ResetPassword(req.params.token);
    if(result) {
        res.status(200).json({
            message: 'Password reset successfully',
        });
    }
    else {
        res.status(500).json({
            message: 'Error',
        });
    }
});


module.exports = router;