# Abalone Analytics

[![Build Status](https://travis-ci.org/rubyforgood/abalone.svg?branch=master)](https://travis-ci.org/rubyforgood/abalone)

The Abalone project is a data tracking and analytics system aimed at storing and measuring data for population trends, mortality rates, and breeding programs. Designed as a multi-tenant application, Abalone will initially serve two stakeholders, the [Bodega Marine Laboratory](https://marinescience.ucdavis.edu/bml/about) at UC Davis and the [Puget Sound Restoration Fund](https://restorationfund.org/) in Washington State.

The Bodega Marine Laboratory's White Abalone captive breeding program is working to prevent the extinction of the [White Abalone](https://www.fisheries.noaa.gov/species/white-abalone) (Haliotis sorenseni), an endangered marine snail. White abalone are one of seven species found in California and are culturally significant to the native people of the area. White abalone were perilously overfished throughout the 20th century, resulting in a 99 percent population decrease by the end of the 1970s. This group is working to reverse their decline and have already seen some great success, they currently have more abalone in the lab than exist in the wild!

The Puget Sound Restoration Fund works to raise and outplant hatchery-reared [Pinto Abalone](https://www.fisheries.noaa.gov/species/pinto-abalone) (Haliotis kamtschatkana), the only abalone species found in the Washington waters. This species has cultural and ecological significance, grazing rock surfaces and maintaining the health of rocky reef habitat and kelp beds. The Washington Department of Fish & Wildlife (WDFW) documented a ~98% decline from 1992 to 2017, leading the pinto abalone to be listed as a State endangered species in 2019.

This application will enable groups to add data either through CSV upload or through the web interface. Groups can view reports and visual representations of key data. Future plans include giving groups the ability to generate custom reports on the fly.

## Getting Started

### Prerequisites
This application is built on following and you must have these installed before you begin:
* Ruby (2.6.6)
* Rails (6.0.3.3)
* PostgreSQL (tested on 9.x)
* Yarn

### Setup
After *forking* this repo and cloning your own copy onto your local machine, execute the following commands in your CLI:
```
gem install bundler
bundle install
yarn install
bin/webpack
rake db:create
rake db:migrate
rake db:seed
```

Webpack dependencies can be rebuilt on command with `bin/webpack`. Alternatively you can run `bin/webpack-dev-server` in another terminal window. This will effectively run `bin/webpack` for you whenever files change.

Then, run `bundle exec rails s` and browse to http://localhost:3000/.

Login information for white abalone:
```
Email: admin@whiteabalone.com
Password: password
```

Login information for pinto abalone:
```
Email: admin@pintoabalone.com
Password: password
```

### Running Background Jobs

The app uses the gem [delayed_job](https://github.com/collectiveidea/delayed_job) for processing CSVs. To run background jobs, run the following command in your CLI:
```
rake jobs:work
```

To confirm background jobs are processing, try uploading a CSV at `http://localhost:3000/file_uploads/new`. You should see the job complete in your CLI and see the file upload results here at `http://localhost:3000/file_uploads`.

To see detailed logs from background jobs, run:
```
tail -f log/delayed_job.log
```

To clear background jobs, run:
```
rake jobs:clear
```

## Docker

We are currently experimenting with Docker for development. While we would love for more people to try it out be forewarned - Docker functionality may not be maintained moving forward. You will need Docker and docker-compose.

* [Docker Desktop](https://www.docker.com/products/docker-desktop) is recommended for Windows and Mac computers.
* The `make` utility can also make your development life easier. It it usually already installed on Linux and Mac computers. For Windows, an easy way to install it is via [Chocolatey](https://chocolatey.org/install), a software package management system similar to Homebrew for Windows. Once Chocolatey is installed, install make with `choco install make` in a command prompt running as Administrator.

### Starting Fresh

To start the application in development mode:

* `docker-compose up --detach db` to start the database
* `docker-compose up --rm schema_migrate` to bring the database schema up-to-date
* `docker-compose up --detach web delayed_job` to start the web and background job processes

Or, run only this:

* `make minty_fresh` to do all of the above

The web app will be available on your host at `http://localhost:3000`. The logs for the web app and delayed_job processes can be seen and followed with the `make watch` command.

### Some Routine Tasks

* `make spec` will run the RSpec tests
* `make lint` will run the Rubocop linting and style checks
* `make test` will run both of the above
* `make build` will build the Docker image for the abalone application. You'll need to run this occasionally if the gem libraries for the project are updated.
* `make database_seeds` will seed the database according to `seeds.rb`.
* `make nuke` will stop all Abalone docker services, remove containers, and delete the development and test databases. This is also used in the `make minty_fresh` command to restart the development and test environment with a clean slate.

### Only the Database

Some developers prefer to run the Ruby and Rails processes directly on their host computers instead of running everything in contianers.
It might still be convenient for those developers to run the database in a container and not deal with the installation of yet another server on their computer.
To do so:

* set an environment variable on your host: `export DATABASE_URL="postgres://dockerpg:supersecret@localhost:54321"`
* start the database with `make database_started`

## Contribute
We would love to have you contribute! Checkout the Issues tab and make sure you understand the acceptance criteria before starting one. Before you start, get familiar with important terms, how the app works right now, sample data and the steps to MVP below:

### Get Familiar with the App

This app is still in early stages of development (MVP). We have defined our [MVP and additional milestones here](https://github.com/rubyforgood/abalone/milestones)

Take a look at the current [Issues](https://github.com/rubyforgood/abalone/issues), which lay out our path to MVP. Feel free to assign one to yourself and take it on! If you have any questions about requirements, post your question in the issue.

### Development
We have included the [Annotate gem](https://github.com/ctran/annotate_models) in this project, for better development experience. It annotates (table attributes) models, model specs, and factories.

The annotate task will run automatically when running migrations. Please see `lib/tasks/auto_annotate_models.rake` for configuration details.

If it does not run automatically, you can run it manually, on the project root dir, with:
```
annotate
```
Check out their Github page for more running options.

### Architectural Constraints
In submitting features or bug fixes, please do not add new infrastructure components — e.g. databases, message queues, external caches — that might increase operational hosting costs. We are hosting on a free Heroku instance and need to keep it this way for the foreseeable future. Come talk to us if you have questions by posting in the Ruby for Good [#abalone](https://rubyforgood.slack.com/archives/CKYAB3G3X) slack channel or creating an [issue](https://github.com/rubyforgood/abalone/issues/new).

### Other Considerations
We want it to be easy to understand and contribute to this app, which means we like comments in our code! We also want to keep the codebase beginner-friendly. Please keep this in mind when you are tempted to refactor that abstraction into an additional abstraction.

### The Problem
Our stakeholder, the Bodega Marine Laboratory, has more data that they can keep track of! They want to have a central data repository for all of their abalone captive breeding data instead of just spreadhseets. It is hard to run reports and anlytics on the data when it's not all in one place.

### The Solution
We are building an app which has the following capabilities:

1. _Store Raw Data_: There are several different types of CSVs that the lab has been amassing (Mortality Tracking Data, Pedigree Data, Population Estimate Data and Wild Collection Data). Examples of these CSVs can be found in the [`db/sample_data_files`](https://github.com/rubyforgood/abalone/tree/master/db/sample_data_files) directory.
2. _Import CSVs_: Users are able to import single and bulk CSVs. Users should generally submit cleaned CSVs, but the app should alert users if there are parsing problems and which row(s) need to be fixed.
3. _Display Charts and Analytics_: For MVP, we would like to display a Histogram binned in 1cm increments of different body lengths for a certain cohort or group of cohorts.
4. _Export CSVs_: TBD.

### Jargon
* **Tag number(s), date** = e.g. `Green_389 from 3/4/08 to 4/6/15` We sometimes tag individuals; however, not all individuals have tags. We can't tag individuals until they are older than one year old because they are too small. Generally a color, a 3-digit number and dates that tag was on. Sometimes tags fall off. It can be logistically challenging to give them the same tag, so they sometimes get assigned new tags. Also, occasionally tags have another form besides color_### (e.g., they have 2 or 4 digits and/or have no color associated with them), and sometimes they are something crazy like, "no tag" or "no tag red zip tie" for animals that lived long ago ... though I suppose we could re-code those into something more tractable.
* **Individual ID** = `YYYY_MM_DD_color_###` The individuals' ID is ithe date it was spawned followed by its initial tag color and 3-digit number
* **Shellfish Health Lab Case Number** = `SF##-##` Animals from each spawning date and from each wild collection have a unique case number created by California's state Shellfish Health Laboratory (SHL). Sometimes animals from a single spawning date have more than one SHL number.
* **Cohort** = `place_YYYY` This is how the lab coloquilly refers to each of their populations spawned on a certain date. It's bascially a note/nickname for each group of animals with a particular SHL #/spawning date.
* **Institution** = e.g. `BML from 6/5/13 - 11/20/14` Animals move around among a finite number of partner institutions (it is possible for new facilities to be added, but it only happens about once every few years).
* **Holding area** = e.g. `Juvenile Rack 1 Column A Trough 3 from 3/4/15 - 6/2/16` This is the tank space by date. This is a note. The types of input will vary significantly within a facility and over time.

[See a full data dictionary here.](https://github.com/rubyforgood/abalone/wiki/Abalone-Data-Dictionary)

## Deployment
The application is currently deployed on Heroku at https://abalone-staging.herokuapp.com/.

## And Don't Forget...

...that Gary needs you.

![a white abalone](https://github.com/rubyforgood/abalone/blob/master/app/assets/images/Burgess%20white%20ab%201.png)

_Photo credit: John Burgess/The Press Democrat_
