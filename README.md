# Home Server

[![Coverage Status](https://img.shields.io/coveralls/github/cpcwood/home-server?style=flat-square&color=sucess)](https://coveralls.io/github/cpcwood/home-server?branch=master) [![CircleCI](https://img.shields.io/circleci/build/gh/cpcwood/home-server?style=flat-square&color=sucess)](https://app.circleci.com/pipelines/github/cpcwood/home-server) [![JavaScript Style Guide](https://img.shields.io/badge/JS_code_style-standard-informational.svg?style=flat-square)](https://standardjs.com)

## Overview

General portfolio style website and a place to prototype new rails features I find interesting.

### Technology

- Ruby v2.7 \w Ruby on Rails v6 & PostgreSQL
- Stimulus
- Google reCaptcha
- Twilio SMS Verification
- Email client
- Docker
- Kubernetes

### Design

| Public sections | Admin sections              |
|-                |-                            |
| Homepage        | Login, 2FA, Password Reset  |
| About me        | Edit sections               |
| Projects        | Add resources               |
| Blog            | Notifications               |
| Code Snippets   | Website analytics           |
| Gallery         | Contact messages            |
| Contact         |                             |



## Setup

### Prerequisites

The application is designed to run in a containerized workflow to allow for good runtime consistency across environments. 

Make sure [docker](https://www.docker.com/) v20.10+ is installed, clone or download the git repository, then move to the project root directory.

### Environment

The application is set up to have three different environments: production, development, test.

### Development

#### Configuration


##### Application

Since the application is designed to be containerized, its configuration is passed through environment variables. 

Development environment variables are loaded from ```config/env/.env``` by docker-compose. Create the ```config/env/.env``` file from the template of required variables in [```config/env/.env.template```](/config/env/.env.template).

#### Install Dependencies

Build the development container images, using ```./tasks build```

In order for commands to run inside the application containers scripts are used instead of calling the commands directly. Scripts are run from the [`tasks`](./tasks) file and the following scripts are current provided:
- ```./tasks/up``` - start the application
- ```./tasks/down``` - stop the application
- ```./tasks/build``` - build the application containers
- ```./tasks/run``` - enter shell or run command in new container by passing arguments
- ```./tasks/exec``` - run command in application container
- ```./tasks/exec``` - enter shell in application container
- ```./tasks/rspec``` - rspec test suite
- ```./tasks/yarn``` - yarn
- ```./tasks/rails``` - rails
- ```./tasks/bundle``` - bundler
- ```./tasks/rubocop``` - run ruby code linter

Then container start up scripts will install the application dependencies automatically on the first run. Updates to dependencies, such as adding a new gem, should be performed manually.

Notes:
- Arguments added to the scripts are passed through.
- To run other commands use the ```docker-compose run``` syntax.

#### Setup Database

The container image [startup script](./.docker/scripts/startup-worker.dev.sh) will automatically create and seed the database on start.

#### Start the Development Server

To start the development server using docker-compose, run: ```./tasks up```

The server should now be running on ```http://0.0.0.0:5000```

### Production
#### Build the Application Containers

The application requires four containers to run:
- application - runs puma application server
- worker - runs sidekiq worker container
- redis - job storage
- psql - database storage

Production containers are expected to be built and pushed to a container repository through CI, see the [CircleCI config file](./.circleci/config.yml). The [`tasks`](./tasks) file also has commands which can be used to build the production containers. 

Note: Make sure to replace the ```cpcwood``` in the container tags with your container repository username and ensure mounted paths are correct for your machine.

#### Deploy

Deploy the application using your container orchestration software, such as [kubernetes](https://kubernetes.io/)

Since the application is designed to be containerized, its configuration is passed through environment variables. Production environment variables should be injected into the container on creation by your container orchestrator.

Sample kubernetes configuration files can be found in [```.kube/```](.kube/).


## Tests

#### Server Tests

RSpec and Capybara are used to run unit and feature tests on the application. 

To run test suite, run ```./tasks rspec``` in the command line.

#### Frontend Tests

Jest is used to test the client frontend JavaScript.

To run the test suite run ```./tasks yarn test``` in the command line.


## Usage

#### Adding Personal Details and Images

Once the application is running, head to the homepage, click on the hamburger icon, and click on login.

Login with your seeded admin credentials.

Click on the site settings tab and add the values or upload:
- website name
- images for the homepage tiles 
- images for the header


## Contributing

Any pull requests are welcome. If you have a question or find a bug, create a GitHub issue.


## LICENSE

This software is distributed under the MIT license.
