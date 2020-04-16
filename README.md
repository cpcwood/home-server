# Home Server

[![Coverage Status](https://coveralls.io/repos/github/cpcwood/home-server/badge.svg?branch=master)](https://coveralls.io/github/cpcwood/home-server?branch=master)
![Build Status](https://api.travis-ci.com/cpcwood/home-server.svg?branch=master&status=started)

## Overview

My home server website built with rails and hosted locally on a RPi.

## Purpose

General portfolio style website and a place to prototype new rails features I find interesting. Other learning objectives are:
- Learning network setup and security (NAT tables, firewalls, etc)
- Nginx reverse proxy
- HTTPS Certificates
- Securing Rails
- CSS and HTML

## Technology

- Ruby 2.6.5
- Ruby on Rails 6.0

## Design

Portfolio sections:
- Homepage
  - Reactive hexagon link tiles with photo and name of each website section
- About me
  - CV / Github CV
- Projects
  - Projects with details, stack, and screenshots
- Blog
  - General blog
- Say Hello
  - A place for visitors to post hello 
  - Email confirmation
  - Email administrator for review and posting
- Contact
  - Contact information
  - Contact box
  - Email confirmation for contactor
  - Email administrator

Admin area:
- Login
- Edit about me section
- Add new project
- Add new blog post
- Manage and confirm say hello posts

## Progress

Complete:
- Setting up RPi
- Set up puma
- Setting up nginx
- Setting up port forwarding
- HTTPS (SSL Certificates LetsEncrypt)
- Puma application server service with systemd
- Test suite
- Database
- CI
- Coverage and build badges

In progress:
- Develop app
  - Create responsive navbar
  - Create homepage

-----------
## How to Install

#### Prerequisites and Dependencies

The application has been developed using Ruby v2.6.5, Ruby on Rails v6.0.2.2, and PostgreSQL 12.1. To setup the application please ensure you have the [Homebrew](https://brew.sh/) or other similar package manager and install the following:
- [Ruby](https://www.ruby-lang.org/en/) v2.6.5 (can be installed from the terminal using the ruby package manager [RVM](https://rvm.io/rvm/install) command ```rvm install 2.6.5```)
- [PostgreSQL](https://www.postgresql.org/) v12.1 (can be installed from the terminal using homebrew ```brew install postgres@12.1```)
- [Yarn](https://yarnpkg.com/) v1.22 (can be installed from the terminal using homebrew ```brew install yarn```)
- [Bundler](https://bundler.io/) v2.1.4 (can be installed from the terminal once ruby is installed using ruby gems ```gem install bundler```)

Once the above has been installed, clone or download the git repository, move to the program root directory, then run the following in the command line to install the program dependencies:

```bash
bundle install
yarn install
```

#### Setup Credentials and Database

The application is set up to have three different environments, if you are developing the application further, please set up credentials for all three, however if you are only installing production, perform all commands with the environment variable ```RAILS_ENV=production```.

Credentials:
- Fill in the template for the global credentials, which be found in ```config/credentials.yml.enc.template```
- Open the rails credentials in your editor of choice ```EDITOR=vim rails credentials:edit``` (if this if your first time opening the credentials, a new rails master key ```config/master.key``` to encrypt the credentials will be generated, do not check this into your version control)
- Add the filled template to the credentials list, then save and exit

To setup the database tables with the correct schema run the following in the command line:
```bash
rails db:create
rails db:migrate
```

#### Server Configuration

The application uses Ruby on Rails default application server: Puma. The configuration for the puma server are in ```config/puma.rb```. The server is currently setup to listen for requests on the local unix socket ```shared/sockets/puma.sock```, to change the server to listen on a localhost port, comment the unix socket line and uncomment the local server port line to host on `http://localhost:3000/`.

#### Running Tests

To check everything is setup correctly, run the application tests below.

Testing Suites: 
- Backend - RSpec, Capybara (to run the backend tests run `rspec` in the command line)
- Frontend - 

#### How to Start the Server

To start the server run ```rails server``` in the relevant RAILS_ENV environment.

-----------
## LICENSE

This software is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.