import ballerina/http;

service /composite on new http:Listener(8080) {

    http:Client userClient = check new ("https://jsonplaceholder.typicode.com");
    http:Client postClient = check new ("https://jsonplaceholder.typicode.com");
    http:Client countryClient = check new ("https://restcountries.com");

    // Proxy GET /composite/users → jsonplaceholder users API
    resource function get users() returns json|error {
        http:Response res = check userClient->get("/users");
        json j = check res.getJsonPayload();
        return j;
    }

    // Proxy GET /composite/posts → jsonplaceholder posts API
    resource function get posts() returns json|error {
        http:Response res = check postClient->get("/posts");
        json j = check res.getJsonPayload();
        return j;
    }

    // Proxy GET /composite/countries → restcountries all countries API
    resource function get countries() returns json|error {
        http:Response res = check countryClient->get("/v3.1/all");
        json j = check res.getJsonPayload();
        return j;
    }

    // Aggregate example: GET /composite/users-and-posts
    resource function get usersAndPosts() returns json|error {
        json users = check (userClient->get("/users")).getJsonPayload();
        json posts = check (postClient->get("/posts")).getJsonPayload();

        json combined = { users: users, posts: posts };
        return combined;
    }
}
