//! DB CONNECTION
const mongoose = require('mongoose');
const { MongoClient, ServerApiVersion } = require('mongodb');
const env = require('dotenv').config();
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
    // console.log(mongoose.models);
    // // write database name to console
    // console.log(`Database: ${dbClient.db().databaseName}`);

    // try {
    //     var User = mongoose.models['User'];
    //     console.log(User);
    //     await User.find({}).exec().catch((err) => {
    //         console.log(err);
    //     }

    //     );
    // } catch (error) {
    //     console.log(error);
    // }
   
});

// dbClient.createConnection = async () => {
//     await mongoose.connect(uri, {
//         useNewUrlParser: true,
//         useUnifiedTopology: true,
//         useCreateIndex: true,
//     });
// }


// dbClient.connect().then(async () => {
//     console.log('Connected successfully to databaase');
//     console.log(mongoose.models);
//     // write database name to console
//     console.log(`Database: ${dbClient.db().databaseName}`);
// });



module.exports = dbClient;