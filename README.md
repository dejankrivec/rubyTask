# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 5 or above

* MySql database
change username password and host in database.yml file to connect to MySql database
set different host for development,test and production 

* bundle install
* rake db:create db:migrate for database
* rails g rspec:install ## for tests
* rake db:seed to generate random flowers

*** tests ***
* rails g rspec:install
* rails db:migrate RAILS_ENV=test

*** run tests ***
* rspec spec/requests/users_spec.rb

Open API x-www-form-urlencoded params

    POST http://localhost:3000/auth/login
        params: email and password
        response: token
    POST http://localhost:3000/auth/register
        params: email, username and password
        response: string message

    http://localhost:3000/getUsers ## just for testing that we know ids
        response: array of users
    http://localhost:3000/getFlowers
        response: array of flowers
    http://localhost:3000/getSightings
        params: flower:

Auth API => Authorization = Bearer + token and content-type = application/x-www-form-urlencoded

    POST http://localhost:3000/createSighting
        params: latitude, longitude, image, flower_id
        response:
            success: json object
            error: message
    http://localhost:3000/destroySighting
        params: sighting_id
        response: message
    http://localhost:3000/likeSighting
        params: sighting_id
        response:
            success: json object
            error: message
    http://localhost:3000/destroyLikes
        params: sighting_id
        response:
            success: json object
            error: message
