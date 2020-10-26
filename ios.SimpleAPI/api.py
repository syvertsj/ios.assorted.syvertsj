#!/usr/bin/env python

import flask

app = flask.Flask(__name__)
#app.config["DEBUG"] = True

@app.route('/', methods=['GET'])
def home():
    return "<h1>Flask Server For Prototype API</h1><p>connect to - localhost:9999/api/v1/data</p>"

# data for api 
data = {'id': 0, 'message':  'our actions are controlled by electronic computers'}

@app.route('/api/v1/data', methods=['GET'])
def api_data():
    return flask.jsonify(data)

@app.route('/post/<string:message>', methods=['POST'])
def show_post(message):
    responseString = "POST submitted - %s" % message
    response = {'message': responseString }
    return flask.jsonify(response)

### top-level code  ###

#app.run()
app.run(port = 9999, debug = True)  # flash runs on port 5000 by default
