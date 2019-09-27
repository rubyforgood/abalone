# Abalone Analytics
The Bodega Marine Laboratory's White Abalone captive breeding program is working to prevent the extinction of the [White Abalone](https://www.biographic.com/posts/sto/fighting-for-a-foothold) (Haliotis sorenseni), an endangered marine snail. White abalone are one of seven species found in California and are culturally significant to the native people of the area. White abalone were perilously overfished throughout the 20th century, resulting in a 99 percent population decrease by the end of the 1970s. This group is working to reverse their decline and have already seen some great success, they currently have more abalone in the lab than exist in the wild!

[Ruby for Good](https://rubyforgood.org/) is supporting these efforts by developing a data tracking and analytics system for Abalone population trends, mortality rates, and breeding programs to help save this species from extinction.

## Getting Started

### Prerequisites
This application is built on following and you must have these installed before you begin:
* Ruby (2.6.3)
* Rails (5.2)
* PostgreSQL (tested on 9.x)

### Setup
After cloning this repo, execute the following commands in your CLI:
```
gem install bundler
bundle install
rake db:create
rake db:migrate
rake db:seed
```

Then, run `bundle exec rails s` and browse to http://localhost:3000/.

## Contribute
We would love to have you contribute! Checkout the Issues tab and make sure you understand the acceptance criteria before starting one.

NOTE: This app is still in early stages of development (MVP). Please notify Ellen Cornelius at gellinellen@gmail.com if you would like to be assigned an issue or if you have questions about requirements.

## Deployment
The application is currently deployed on a DigitalOcean droplet via Capistrano. Once your public SSH key has been added to the appropriate user on the necessary server(s), use `bundle exec cap production deploy` to deploy the application, run migrations, and restart the Puma application server. Puma is reverse-proxied behind Nginx. The Nginx configuration is currently maintained outside of the Rails development pipeline. Currently live at [abalone.blrice.net](http://abalone.blrice.net/).

## And Don't Forget...

...that Gary needs you. 

![a white abalone](https://github.com/rubyforgood/abalone/blob/master/app/assets/images/Burgess%20white%20ab%201.png)

_Photo credit: John Burgess/The Press Democrat_

