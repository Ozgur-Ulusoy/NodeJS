//! DB CONNECTION
const { MongoClient, ServerApiVersion } = require('mongodb');
const uri =`mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@cluster0.fq1duvn.mongodb.net/DB?retryWrites=true&w=majority`;

const dbClient = new MongoClient(uri, {
    serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
    useNewUrlParser: true,
    useCreateIndex: true,
    useUnifiedTopology: true,
    }
});

dbClient.connect().then(async () => {
    console.log('Connected successfully to databaase');
});

module.exports = dbClient;