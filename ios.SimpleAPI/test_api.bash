#!/usr/bin/env bash

host=localhost
port=9999
api_path=api/v1/data
post=post/a_url_message

# GET from API
sample_get () { curl http://$host:$port/$api_path; } 

# POST
sample_post () { echo  | curl -d @- http://$host:$port/$post; } 

usage () { echo "usage: $0 [get|post]"; }

# top-level code
case "$1" in get) sample_get ;; post) sample_post ;; *) usage ;; esac


