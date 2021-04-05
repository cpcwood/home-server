# Home Server

[![Coverage Status](https://img.shields.io/coveralls/github/cpcwood/home-server?style=flat-square&color=sucess)](https://coveralls.io/github/cpcwood/home-server?branch=master) [![CircleCI](https://img.shields.io/circleci/build/gh/cpcwood/home-server?style=flat-square&color=sucess)](https://travis-ci.com/github/cpcwood/home-server) [![JavaScript Style Guide](https://img.shields.io/badge/JS_code_style-standard-informational.svg?style=flat-square)](https://standardjs.com)

## Overview

General portfolio style website and a place to prototype new rails features I find interesting.

### Technology

- Ruby v2.7.2 \w Ruby on Rails v6 & PostgreSQL
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

The application is designed to run a containerized workflow to allow for the best runtime conisitency across environments. 

Make sure [docker](https://www.docker.com/) v20+ is installed, clone or download the git repository, then move to the project root directory.

### Environment

The application is set up to have three different environments: production, development, test.

### Development

#### Configuration


##### Application

Since the application is designed to be containerized, its configuration is passed through environment variables. 

Development environment variables will be loaded from ```config/env/.env``` by docker-compose. Create the ```config/env/.env``` file from the template of required variables in [```config/env/.env.template```](/config/env/.env.template).

##### Docker Compose

The psql database and redis containers require persistent storage in development. Create data directories for both of these containers, then use the template [```.env.template```](./.env)to create a ```.env``` file in the root directory with these data directories.


#### Install Dependencies

Build the development container images, using ```bin/d/build```

Then run the following commands to install the application dependencies:

```bash
.bin/d/bundle install
bin/d/yarn install
```

Note: Sripts are used instead of running the commands directly so the commands run inside the application container, allowing for a consistent environment. The following scripts are current provided:
- ```bin/d/up``` - start the application
- ```bin/d/down``` - stop the application
- ```bin/d/build``` - build the application containers
- ```bin/d/run``` - run any shell command
- ```bin/d/rspec``` - rspec test suite
- ```bin/d/yarn``` - yarn
- ```bin/d/rails``` - rails
- ```bin/d/bundle``` - bundler

Notes:
- Arguments added to the scripts are passed through.
- To run other commands use the ```docker-compose run``` syntax.

#### Setup Database

The container image [startup script](./.docker/scripts/startup-worker.dev.sh) will automatically create and seed the database on start.

#### Start the Development Server

To start the development server using docker-compose, run: ```bin/d/up```

The server should now be running on ```http://0.0.0.0:5000```

### Production
#### Build the Application Containers

The application requires four containers to run:
- application - runs puma application server
- worker - runs sidekiq worker container
- redis - job storage
- psql - database storage

The file [tasks-docker.txt](tasks-docker.txt) contains the commands required to build the containers for the application. The circle-ci [```.config```](./.circleci/config.yml) is set to build and push the containers automatically during the CI/CD pipeline.

Note: Make sure to replace ```cpcwood``` with your dockerhub username and ensure mounted paths are correct for your machine.

#### Deploy

Deploy the application using your container orchestration software, such as [kubernetes](https://kubernetes.io/)

Since the application is designed to be containerized, its configuration is passed through environment variables. Production environment variables should be injected into the container on creation by your container orchestrator.

Sample kubernetes configuration files can be found in [```.kube/```](.kube/).


## Tests

#### Server Tests

RSpec and Capybara are used to run unit and feature tests on the appliation. 

To run test suite, run ```bin/d/rspec``` in the command line.

#### Frontend Tests

Jest is used to test the client frontend JavaScript.

To run the test suite run ```bin/d/yarn test``` in the command line.


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

This software is distributed under the MIT license
