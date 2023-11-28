# README

# Project Name

Restaurant Search

## Project Overview

An API based application to search restaurant based on text input.


## Features

=> User can search restaurant based on the input, it will return related restaurant names, address and photos
=> User can mark any restaurant as favourite too.


### Prerequisites

* Ruby version  => "3.0.00"
* Rails version => "7.1.2"
* psql (PostgreSQL) 12.16

### Installation

1. Clone the repository
2. Navigate to the project directory: `cd restaurant_search`
3. Install dependencies: `bundle install`
4. Set up the database: 
    `rails db:create`
    `rails db:migrate`
    `rails db:seed`
5. Start the Rails server: `rails server`
6. Postman API Collection
    https://api.postman.com/collections/31296639-20474ea4-70f9-48ad-9e64-16bae25537a6?access_key=PMAT-01HFX9R2B8WX15J9529CEW2V87

### With Docker
Before using docker update the credentials in docker-compose.yml
1. sudo docker build -t restaurant_search .
2. sudo docker-compose up



## Usage

First Need to login with one of these credentials
-> email: "user1@yopmail.com", password: 'password'
-> email: "user2@yopmail.com", password: 'password'

Once you sign in 
You'll get AUTH TOKEN in response
which needs to be pass in other API in header for authentication
