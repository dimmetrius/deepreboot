const functions = require('firebase-functions');
const configureServer = require('./server');

// initialize the server
const server = configureServer();
// create and export the api
const api = functions.https.onRequest(server);
module.exports = {api};
