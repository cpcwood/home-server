# Home Server

[![Coverage Status](https://img.shields.io/coveralls/github/cpcwood/home-server?style=flat-square&color=sucess)](https://coveralls.io/github/cpcwood/home-server?branch=master) [![Build Status](https://img.shields.io/travis/com/cpcwood/home-server?style=flat-square&color=sucess)](https://travis-ci.com/github/cpcwood/home-server) [![JavaScript Style Guide](https://img.shields.io/badge/JS_code_style-standard-informational.svg?style=flat-square)](https://standardjs.com)

## Overview

General portfolio style website and a place to prototype new rails features I find interesting. Other learning objectives are:
- Learning network setup and security (NAT tables, firewalls, etc)
- Nginx reverse proxy
- HTTPS Certificates
- Securing Rails
- General Rails processes
- CSS and HTML
- Stimulus JavaScript Framework

## Technology

- Ruby 2.7.0
- Ruby on Rails 6.0
- StimulusJS
- PostgreSQL v12.1
- Google reCaptcha
- Twilio SMS Verification
- Email client

## Design

Public sections:
- Homepage
  - Reactive link tiles with photo and name of each website section
- About me
  - CV / Github CV / Headshot (updatable from admin page)
- Projects
  - Projects with details, stack, and screenshots
    - overview of all
    - click to enter detail view
- Blog
  - General blog (admin can add/delete/update posts)
    - overview of all
    - click to enter post, comments section at bottom (admin review of comments before public)
- Say Hello
  - A place for visitors to post hello 
  - Email confirmation
  - Email administrator for review and posting
- Gallery
  - General gallery for admin to post photos
  - Optional folders
  - Metadata remover on upload
- Contact
  - Contact information
  - Contact box
  - Email confirmation for contactor
  - Email administrator

Admin sections:
- Login, 2FA, Password Reset
- Edit sections
- Add new project
- Add new blog post
- Notifications to confirm say hello posts and comments on blog
- Website analytics

-----------
## How to Install and Setup

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

The following services should be running before the start of the server:
- [Sidekiq](https://github.com/mperham/sidekiq) v6.0.7 - should be running before start of server (already installed via Gemfile, started using ```bundle exec sidekiq -C config/sidekiq.yml``` either automatically using systemd (or other process manager) or in terminal window)
- [Redis](https://redislabs.com/get-started-with-redis/) v5.0.7 - required for persistent jobs with sidekiq in case of server shutdown (can be installed from the terminal using homebrew ```brew install redis```, then started using ```brew services start redis```)

#### Setup Credentials and Database

The application is set up to have three different environments, if you are developing the application further, please set up credentials for all three, however if you are only installing production, perform all commands with the environment variable ```RAILS_ENV=production```.

Global Credentials:
- Fill in the template for the global credentials, which be found in ```config/credentials.yml.enc.template```
- Open the rails credentials in your editor of choice ```EDITOR=vim rails credentials:edit``` (if this if your first time opening the credentials, a new rails master key ```config/master.key``` to encrypt the credentials will be generated, do not check this into your version control)
- Add the filled template to the credentials list, then save and exit

Test Credentials:
- Fill in the template for the global credentials, which be found in ```config/credentials/test.yml.enc.template```
- Open the rails credentials in your editor of choice ```EDITOR=vim rails credentials:edit --environment test```
- Add the filled template to the credentials list, then save and exit

To setup the database tables with the correct schema run the following in the command line:
```bash
rails db:create
rails db:migrate
rails db:seed
```

Note: For your personal admin login details, edit the database seed in ```db/seeds.rb``` or manually add admin profile to the database

#### Server Configuration

The application uses Ruby on Rails default application server: Puma. The configuration for the puma server are in ```config/puma.rb```. The server is currently setup to listen for requests on the local unix socket ```shared/sockets/puma.sock```, to change the server to listen on a localhost port, comment the unix socket line and uncomment the local server port line to host on `http://localhost:3000/`.

#### Running Tests

To check everything is setup correctly, RSpec and Capybara are used to run unit and feature tests respectively. 

To run tests run `rspec` in the command line

#### How to Start the Server

```bundle exec sidekiq -C config/sidekiq.yml```
```brew services start redis```

To start the server run ```rails server``` in the relevant RAILS_ENV environment.


#### Adding Personal Details and Images

Head to the homepage, click on the hamburger icon, and click on login.

Login with your seeded admin credentials.

Click on the site settings tab and add the values or upload:
- website name
- images for the homepage tiles 
- images for the header

-----------
## How to Use

Login in as admin then head to the section of the site you wish to add content:

#### About

Click edit header open options for adding markdown content and changing the profile image

#### Projects

Click edit header open options for adding new projects

To edit a project, enter the project by clicking on view more, then click edit header open options for editing

#### Blog

#### Say Hello

#### Gallery

#### Contact

-----------
## LICENSE

This software is distributed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.