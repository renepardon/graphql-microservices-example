const express = require('express'),
	app = express(),
	PORT = process.env.PORT || 8080,
	SERVICE_1_HOST = process.env.SERVICE_1_HOST || 'localhost',
	SERVICE_1_PORT = process.env.SERVICE_1_PORT || '8082',
	SERVICE_2_HOST = process.env.SERVICE_2_HOST || 'localhost',
	SERVICE_2_PORT = process.env.SERVICE_2_PORT || '8083',
	bodyParser = require('body-parser'),
	{ graphqlExpress } = require('apollo-server-express'),
	{ mergeSchemas } = require('graphql-tools'),
	{ getIntrospectSchema } = require('./introspection');

//our graphql endpoints
const endpoints = [
	`http://${SERVICE_1_HOST}:${SERVICE_1_PORT}/graphql`,
	`http://${SERVICE_2_HOST}:${SERVICE_2_PORT}/graphql`,
];
//async function due to the async nature of grabbing all of our introspect schemas
(async function () {
	try {
		//promise.all to grab all remote schemas at the same time, we do not care what order they come back but rather just when they finish
		allSchemas = await Promise.all(endpoints.map(ep => getIntrospectSchema(ep)));
		app.get('/health-check', (req, res) => {
			res.send("Health check passed");
		});
		//create function for /graphql endpoint and merge all the schemas
		app.use('/graphql', bodyParser.json(), graphqlExpress({ schema: mergeSchemas({ schemas: allSchemas }) }));
		//start up a graphql endpoint for our main server
		app.listen(PORT, () => console.log('GraphQL API listening on port:' + PORT));
	} catch (error) {
		console.log('ERROR: Failed to grab introspection queries', error);
	}
})();


