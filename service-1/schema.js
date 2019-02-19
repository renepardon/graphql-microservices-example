const {makeExecutableSchema} = require('graphql-tools');
const data = require('./data');

// SCHEMA DEFINITION
const typeDefs = require('./schema.graphql')

// RESOLVERS
const resolvers = {
    Query: {
        userById: (root, args, context, info) => {
            return data.find(item => item.id == args.id);
        }
    },
}

// (EXECUTABLE) SCHEMA
module.exports = makeExecutableSchema({
    typeDefs,
    resolvers
});