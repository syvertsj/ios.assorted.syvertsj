#!/usr/bin/env node

const express = require("express")
const app = express()
const port = 9999

// homepage message
app.get("/", (request, result) => {
    result.send("<h1>Node.js/Express.js Server Prototype API</h1><p>connect to - localhost:9999/api/v1/data</p>")
})

// api path 
app.get("/api/v1/data", (request, result) => {
    console.log("result: ", result.json)
    data = {'id': 0, 'message':  'our actions are controlled by electronic computers'}
    result.send(data)
})

// api path - /post
// parameter - post_message (request.params.post_message)
app.post("/post/:post_message", (request, result) => {
    console.log("result: ", result.json)
    console.log("request.header: ", request.header)
    console.log("request.headers: ", request.headers)
    console.log("request.body: ", request.body)
    console.log("request.url: ", request.url)
    console.log("request.param: ", request.param)
    console.log("request.params: ", request.params)

    const postMessage = request.params.post_message
    const responseString = "POST received: " + postMessage

    result.send({ 'message': responseString })
})

app.listen(port, () => {
    console.log("server is running on port: ", port)
})