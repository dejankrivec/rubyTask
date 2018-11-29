# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 5 or above

* MySql database

* run bundle install

* run rake db:migrate for database

* run rake db:seed to generate random flowers

Open API x-www-form-urlencoded params

    POST http://localhost:3000/auth/login
        params: email and password
        response: token
    POST http://localhost:3000/auth/register
        params: email, username and password
        response: string message

    http://localhost:3000/getUsers ## just for testing that we know ids
        response: array of users
    http://localhost:3000/getFlowers ## just for testing that we know ids
        response: array of flowers
    http://localhost:3000/getSightings
        params: flower:integer

Auth API => Authorization = Bearer + token and content-type = application/x-www-form-urlencoded

    POST http://localhost:3000/createSighting
        params: latitude, longitude, image, user_id, flower_id
        response:
            success: json object
            error: message
    http://localhost:3000/destroySighting
        params: user_id and sighting_id
        response: message
    http://localhost:3000/likeSighting
        params: user_id and sighting_id
        response:
            success: json object
            error: message
    http://localhost:3000/destroyLikes
        params: user_id and sighting_id
        response:
            success: json object
            error: message
