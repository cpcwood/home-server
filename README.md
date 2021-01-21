# Home Server

[![Coverage Status](https://img.shields.io/coveralls/github/cpcwood/home-server?style=flat-square&color=sucess)](https://coveralls.io/github/cpcwood/home-server?branch=master) [![Build Status](https://img.shields.io/travis/com/cpcwood/home-server?style=flat-square&color=sucess)](https://travis-ci.com/github/cpcwood/home-server) [![JavaScript Style Guide](https://img.shields.io/badge/JS_code_style-standard-informational.svg?style=flat-square)](https://standardjs.com)

## Overview

General portfolio style website and a place to prototype new rails features I find interesting. Other learning 

### Technology

- Ruby v2.7.2
- Ruby on Rails v6
- StimulusJS
- PostgreSQL v12
- Google reCaptcha
- Twilio SMS Verification
- Email client

### Design

Public sections:
- Homepage
- About me
- Projects
- Blog
- Code Snippets
- Gallery
- Contact

Admin sections:
- Login, 2FA, Password Reset
- Edit sections
- Add resources
- Notifications
- Website analytics

-----------
## Configuration
#### Prerequisites and Dependencies

The application has been developed using Ruby v2.7.2, Ruby on Rails v6, and PostgreSQL 12.1. 

To setup the application please ensure you have the [Homebrew](https://brew.sh/) (assuming macOS) or other similar package manager and install the following:

- [Ruby](https://www.ruby-lang.org/en/) v2.7.2 (can be installed from the terminal using the ruby package manager [RVM](https://rvm.io/rvm/install) command ```rvm install 2.7.2```)
- [PostgreSQL](https://www.postgresql.org/) v12.1 (can be installed from the terminal using homebrew ```brew install postgres@12.1```)
- [Yarn](https://yarnpkg.com/) (can be installed from the terminal using homebrew ```brew install yarn```)
- [Bundler](https://bundler.io/) v2.1.4 (can be installed from the terminal once ruby is installed using ruby gems ```gem install bundler```)

Once the above has been installed, clone or download the git repository, move to the program root directory, then run the following in the command line to install the program dependencies:

```bash
bundle install
yarn install
```

The following services should be running before the start of the server:
- [Sidekiq](https://github.com/mperham/sidekiq) v6 - should be running before start of server (already installed via Gemfile, started using ```bundle exec sidekiq -C config/sidekiq.yml``` either automatically using systemd (or other process manager) or in terminal window)
- [Redis](https://redislabs.com/get-started-with-redis/) v5 - required for persistent jobs with sidekiq in case of server shutdown (can be installed from the terminal using homebrew ```brew install redis```, then started using ```brew services start redis```)

#### Setup Environment

The application is set up to have three different environments: production, development, test.

Since the application is designed to be containeized, the configuration is passed through environment variables. A template for the required variables can be found in ```config/env/.env.template```

To make things more managable in development and test environments, .env files are loaded from ```config/env/.env``` and ```config/env/test.env``` respectively. Create these files from the template using your env specific credentials.


#### Setup Database

To setup the database tables with the correct schema run the following in the command line:
```sh
rails db:create
rails db:migrate
rails db:seed
```

Note: For your personal admin login details either: edit the database seed in ```db/seeds.rb```, update the credentials on the site, or manually add admin profile to the database.

#### Server Configuration

The application uses Ruby on Rails default application server: Puma. The configuration for the puma server are in ```config/puma.rb```. By default the server is setup to listen for requests on ```http://localhost:3000/```.

## Tests

#### Server Tests

RSpec and Capybara are used to run unit and feature tests on the server. 

To run test suite run ```bundle exec rspec``` in the command line.

#### Frontend Tests

Jest is used to test the client frontend JavaScript.

To run the test suite run ```yarn test``` in the command line.

-----------
## Usage

### Development
#### Start the Development Server

##### macOS
Start redis: ```brew services start redis```
Start postgresql: ```brew services start postgresql```
Start background worker: ```bundle exec sidekiq -C config/sidekiq.yml```
Start dev server: ```rails server -b 0.0.0.0 -p 5000 -e development```

##### Docker
The file [tasks-docker.txt](tasks-docker.txt) contains the commands required to start the containers for the application.

### Production
#### Build the Application Containers

The application requires four containers to run:
- application - runs puma application server
- worker - runs sidekiq worker container
- redis - job storage
- psql - database storage


The file [tasks-docker.txt](tasks-docker.txt) contains the commands required to build the containers for the application. 

Note: Replace ```cpcwood``` with your dockerhub username and ensure mounted paths are correct.

#### Adding Personal Details and Images

Once the application is running, head to the homepage, click on the hamburger icon, and click on login.

Login with your seeded admin credentials.

Click on the site settings tab and add the values or upload:
- website name
- images for the homepage tiles 
- images for the header

-----------
## LICENSE

This software is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.