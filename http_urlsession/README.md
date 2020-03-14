# iOS: Http Request And JSON Response Handling Using URLSession And JSONDecoder

syvertsj

Submit api call to worldtimeapi.org to obtain some information:
    - client ip
    - time zone
    - date time
    - abbreviation for current time zone (ie: EDT)

 --------------------------------------------------------------------------------

This uses the following Apple Foundation classes:

    - URLSession http request and response handling  
    - JSONDecoder Codable protocol for JSON marshalling and unmarshalling

 --------------------------------------------------------------------------------

The TimezoneResponse struct is a Codable object with properties matching what is 
    received in a 'curl' request to the api.

curl "http://worldtimeapi.org/api/timezone/America/New\_York"

The api on the worldtimeapi.org site did not show a definition for an error key, 
    however, using 'curl' with a faulty request showed it.

curl "http://worldtimeapi.org/api/timezone/America/Wrong\_New\_York"

response:
    {"error":"unknown location"}

 --------------------------------------------------------------------------------
