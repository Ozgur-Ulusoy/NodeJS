const express = require('express');
const router = express.Router();
const {Login, Logout, CheckSession} = require('../Controllers/auth');

router.post('/login/:username/:password', async (req, res, next) => {
    const {username, password} = req.params;
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

router.post('/logout/:token', async (req, res, next) => {
    const {token} = req.params;
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

router.get('/checkSession/:token', async (req, res, next) => {
    const {token} = req.params;
    var result = await CheckSession(token);
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

module.exports = router;