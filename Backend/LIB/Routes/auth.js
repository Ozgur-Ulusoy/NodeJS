const express = require('express');
const router = express.Router();
const {Login, Logout, CheckSession} = require('../Controllers/auth');

router.post('/login', async (req, res, next) => { // /:username/:password
    const username = req.headers.username;
    const password = req.headers.password;

    var result = await Login(username, password);
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
    const token = req.headers.token;
    const result = await Logout(token);
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
    const token = req.headers.token;
    var result = await CheckSession(token);
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

module.exports = router;