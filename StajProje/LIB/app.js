const express = require('express');
const app = express();
const morgan = require('morgan');
const bodyParser = require('body-parser')

app.use(morgan('dev')); //* use morgan to log requests in console
app.use(bodyParser.urlencoded({extended: false})); //* use body-parser to parse urlencoded bodies
app.use(bodyParser.json()); //* use body-parser to parse json bodies

//* CORS error handling
app.use((req, res, next) => { //* set headers to allow CORS
    res.header('Content-Type', 'application/json'); //* json response
    res.header('Access-Control-Allow-Origin', '*'); //* allow all origins
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization'); //* allow headers
    if (req.method === 'OPTIONS') { //* browser always sends OPTIONS request first
        res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET'); //* allow methods
        return res.status(200).json({}); //* return empty json response
    }
    next(); //* forward request
});

//* Routes
// const userRoutes = require('./API/Routes/user');
const postRoutes = require('./Routes/post');
const commentRoutes = require('./Routes/comment');

// app.use('api/user', userRoutes); //* handle requests to /user
app.use('/api/post', postRoutes); //* handle requests to /post
app.use('/api/comment', commentRoutes); //* handle requests to /comment

//* Error Handling
app.use((req, res, next) => { 
    const error = new Error('Not found');
    error.status = 404;
    res.status(error.status).json({ //* return json response
        error: {
            message: error.message
        }
    });
});

module.exports = app; //* export app