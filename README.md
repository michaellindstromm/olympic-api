# Olympic-API

The Olympic API allows developers to access historical olympic data from 1896 - 2014. The API was built with Ruby on Rails, and architected strictly around REST principles. Users can sign up, which grants access by way of JSON Web Tokens. Full documentation is provided including endpoints, error handling, access, and a dedicated try server. The try server allows for real time requests to the database. 

---

## Getting Started

To access locally simply clone down the repo to your machine.

 ```
 git clone https://github.com/michaellindstromm/olympic-api.git
 ```


### Prerequisites

Ensure your machine has the following installed.

```
ruby 
```

### Installing

Go to root directory of the app.
```
cd [wherever you put the app]
```

Bundle install the necessary gems from the Gemfile.
```
bundle install
```

Create the database.
**Note: This will take several minutes.**

```
rails db:create
rails db:migrate
rails db:seed
```
---

## Getting Data

After seeding is complete. Test by creating a user and returning some data.

Start your server.
```
rails s
```

Create a user.
```
curl -H "Content-Type: application/json" -X POST -d '{"email":"example@mail.com","password":"123123123"}' http://localhost:3000/authenticate
```

This will return a JSON Web Token which will look something like this.
```
{"auth_token":"eyJ0eXAiOiKHV1QiLCJhbGbpErJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjF1NjA2NTgxODZ9.xsSwcPC22IR71OBv6bU_OGCSyfE81DvEzWfDU0iybMA"}
```

Get some data.
```
curl -H "Authorization: eyJ0eXAiOiKHV1QiLCJhbGbpErJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjF1NjA2NTgxODZ9.xsSwcPC22IR71OBv6bU_OGCSyfE81DvEzWfDU0iybMA" -H "Accept: version=v2" http://localhost:3000/api/sports
```

---

## Built With

* [Ruby on Rails](http://rubyonrails.org/)


## Live

Visit [https://olympicapi.herokuapp.com](https://olympicapi.herokuapp.com) to view documentation and learn more about the API.

![alt text](https://github.com/michaellindstromm/olympic-api/blob/master/app/assets/images/olympic_icon.png)

