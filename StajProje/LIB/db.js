//! DB CONNECTION
const { MongoClient, ServerApiVersion } = require('mongodb');
const env = require('dotenv').config();
const uri =`mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@cluster0.fq1duvn.mongodb.net/?retryWrites=true&w=majority`;

const dbClient = new MongoClient(uri, {
    serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
    }
});

module.exports = dbClient;