// require all dependencies to set up server
const express = require('express');
const {ApolloServer, UserInputError} = require('apollo-server-express');

const typeDefs = require('./schema');
// cors allows our server to accept requests from different origins
const cors = require('cors');

const {google} = require('googleapis');

const configureServer = () => {
// invoke express to create our server
  const app = express();
  // use the cors middleware
  app.use(cors());
  // Very simple resolver that returns "world" for the hello query

  const identityToolkit = google.identitytoolkit({
    auth: 'GCP_API_KEY',
    version: 'v3',
  });

  app.post('/sendSMS', async (req, res) => {
    const {phoneNumber, recaptchaToken} = req.body;

    const response = await identityToolkit.relyingparty.sendVerificationCode({
      phoneNumber,
      recaptchaToken: recaptchaToken,
    });

    // save sessionInfo into db. You will need this to verify the SMS code
    const sessionInfo = response.data.sessionInfo;
    return sessionInfo;
  });

  app.post('/verifySMS', async (req, res) => {
    const {verificationCode, phoneSessionId} = req.body;

    await identityToolkit.relyingparty.verifyPhoneNumber({
      code: verificationCode,
      sessionInfo: phoneSessionId,
    });

    // verification code accepted, update phoneNumberVerified flag in database
    // ...
  });

  app.use('/graphql', function(req, res, next) {
    // console.log('Request URL:', req.originalUrl);
    next();
  });

  const resolvers = {
    Product: {
      creator: (parent, args, context, info) => {
        console.log('USER_CREATOR');
        return {
          id: JSON.stringify({parent, args}),
        };
      },
      /*
      getDemo: (parent, args, context, info) => {
        return {
          id: JSON.stringify({parent, args}),
        };
      },
      */
    },
    Food: {
      __resolveType(book, context, info) {
        if (book.isProduct) {
          return 'Product';
        }

        if (book.isReceipt) {
          return 'Receipt';
        }

        return null;
      },
    },
    Query: {
      products: (parent, args, context, info) => {
        console.log('query.products');
        if (args && args.where) {
          args.where.forEach((_where) => {
            if (_where.id && Object.keys(_where.id).length > 1) {
              throw new UserInputError('Only one key expected: ' + Object.keys(_where.id).join(' or '), {
                invalidArgs: Object.keys(args),
              });
            }
          });
        }
        return [{
          id: Math.random().toString(),
          name: 'Name',
          kkal: Math.random(),
          protein: Math.random(),
          fat: Math.random(),
          carb: Math.random(),
          sugar: Math.random(),
          fibers: Math.random(),
        }];
      },
      meals: () => [],
    },
  };

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    formatError: (err) => {
      // Don't give the specific errors to the client.
      if (err.message.startsWith('Wrong Arguments')) {
        return new Error('Internal server error');
      }
      if (err && err.extensions && err.extensions.exception && err.extensions.exception.stacktrace) {
        err.extensions.exception.stacktrace = undefined;
      }
      return err;
    },
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
