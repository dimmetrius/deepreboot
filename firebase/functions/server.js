// require all dependencies to set up server
const express = require('express');
const {ApolloServer} = require('apollo-server-express');
const typeDefs = require('./schema');
// cors allows our server to accept requests from different origins
const cors = require('cors');
const configureServer = () => {
// invoke express to create our server
  const app = express();
  // use the cors middleware
  app.use(cors());
  // Very simple resolver that returns "world" for the hello query
  const resolvers = {
    Query: {
      getGame: () => null,
      products: (filters) => [],
    },
  };
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: ({req, res}) => {
      return {
        headers: req.headers,
        req,
        res,
      };
    },
  });
  // now we take our newly instantiated ApolloServer and apply the   // previously configured express application
  server.applyMiddleware({app});
  // finally return the application
  return app;
};

module.exports = configureServer;
