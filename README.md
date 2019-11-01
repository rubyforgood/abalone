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
After *forking* this repo and cloning your own copy onto your local machine, execute the following commands in your CLI:
```
gem install bundler
bundle install
rake db:create
rake db:migrate
rake db:seed
```

Then, run `bundle exec rails s` and browse to http://localhost:3000/.

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

## Contribute
We would love to have you contribute! Checkout the Issues tab and make sure you understand the acceptance criteria before starting one. Before you start, get familiar with important terms, how the app works right now, sample data and the steps to MVP below:

### Get Familiar with the App

This app is still in early stages of development (MVP). We have defined our [MVP and additional milestones here](https://github.com/rubyforgood/abalone/milestones)

Take a look at the current [Issues](https://github.com/rubyforgood/abalone/issues), which lay out our path to MVP. Feel free to assign one to yourself and take it on! If you have any questions about requirements, post your question in the issue or email Ellen Cornelius at gellinellen@gmail.com.

### Development
We have included the [Annotate gem](https://github.com/ctran/annotate_models) in this project, for better development experience. It annotates (table attributes) models, model specs, and factories.

The annotate task will run automatically when running migrations. Please see `lib/tasks/auto_annotate_models.rake` for configuration details.

If it does not run automatically, you can run it manually, on the project root dir, with:
```
annotate
```
Check out their Github page for more running options.

### The Problem
Our stakeholder, the Bodega Marine Laboratory, has more data that they can keep track of! They want to have a central data repository for all of their abalone captive breeding data instead of just spreadhseets. It is hard to run reports and anlytics on the data when it's not all in one place.

### The Solution
We are building an app which has the following capabilities:
1. _Store Raw Data_: There are several different types of CSVs that the lab has been amassing (Mortality Tracking Data, Pedigree Data, Population Estimate Data, Spawning Success Data, Tagged Animal Assessment Data, Untagged Animal Assessment Data, and Wild Collection Data). Examples of these CSVs can be found in the [`db/sample_data_files`](https://github.com/rubyforgood/abalone/tree/master/db/sample_data_files) directory.
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


### CSV Upload Architecture

![file upload architecture diagram](https://github.com/rubyforgood/abalone/blob/master/app/assets/images/abalone_upload_job.jpeg)

## Deployment
The application is currently deployed on a DigitalOcean droplet via Capistrano. Once your public SSH key has been added to the appropriate user on the necessary server(s), use `bundle exec cap production deploy` to deploy the application, run migrations, and restart the Puma application server. Puma is reverse-proxied behind Nginx. The Nginx configuration is currently maintained outside of the Rails development pipeline. Currently live at [abalone.blrice.net](http://abalone.blrice.net/).

## And Don't Forget...

...that Gary needs you.

![a white abalone](https://github.com/rubyforgood/abalone/blob/master/app/assets/images/Burgess%20white%20ab%201.png)

_Photo credit: John Burgess/The Press Democrat_

