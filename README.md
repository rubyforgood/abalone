# Abalone Analytics
The Bodega Marine Laboratory's White Abalone captive breeding program is working to prevent the extinction of the White Abalone (Haliotis sorenseni), an endangered marine snail. White abalone are one of seven species found in California and are culturally significant to the native people of the area. White abalone were perilously overfished throughout the 20th century, resulting in a 99 percent population decrease by the end of the 1970s. This group is working to reverse their decline and have already seen some great success, they currently have more abalone in the lab than exist in the wild! Ruby for Good is supporting these efforts by developing a data tracking and analytics system for Abalone population trends, mortality rates, and breeding programs to help save this species from extinction.

Currently live at [abalone.blrice.net](http://abalone.blrice.net/).

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


## Deployment
The application is currently deployed on a DigitalOcean droplet via Capistrano. Once your public SSH key has been added to the appropriate user on the necessary server(s), use `bundle exec cap production deploy` to deploy the application, run migrations, and restart the Puma application server. Puma is reverse-proxied behind Nginx. The Nginx configuration is currently maintained outside of the Rails development pipeline.
