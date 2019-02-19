const {makeExecutableSchema} = require('graphql-tools');
const data = require('./data');

// SCHEMA DEFINITION
const typeDefs = require('./schema.graphql');

// RESOLVERS
const resolvers = {
    Query: {
        articleById: (root, args, context, info) => {
            return data.find(item => item.id === parseInt(args.id));
        },
        articlesByUserId: (root, args, context, info) => {
            return data.filter(item => item.userId === parseInt(args.userId));
        }
    },
};

// (EXECUTABLE) SCHEMA
module.exports = makeExecutableSchema({
    typeDefs,
    resolvers
});