# Application Overview

__Last updated: August 2021__

This document provides a general overview of the key parts of the Abalone Analytics application. It is primarily intended to help facilitate on-boarding of developers that are new to the application. As the application evolves, so will this document. PRs with updates and improvements are welcome!!

## Purpose

This application is designed to be a custom solution for the intake, storage and reporting of data used by conservation researches, specifically the initial stakeholders who conduct research on Abalone. The development work on this application is done on a volunteer basis and the application is offered for free. 

## Features

### Data Import

The application accepts measurement imports in the form of csv files. This is the primary method for ongoing data imports. The concept of a measurement is designed to flexible and allow for future modifications with requiring extensive code refactoring.  

The application also accepts direct imports for several models in the system. These imports are most applicable when a new organization comes on board and needs to populate their initial set data.

### Data Storage

Imported data is currently stored in the database and presented using a combination of standard rails view (Animals index, Cohorts index, etc.) and the reporting interface described below. We expect the storage and presentation of data to evolve to suite the needs of the application's initial stakeholders.

### Reporting

The application makes use of the [Blazer gem](https://github.com/ankane/blazer) as the primary reporting tool. Blazer allows organizations to create standard reports based on their data, create dashboards populated with multiple reports, generate charts based on data and conduct direct sql queries against their organization's data.

## Application Architecture

### Multi-tenancy

This application is multi-tenant meaning that each organization has its own templated, walled-off section of the application. Users within an organization can view data, import and update data without affecting the data of other organizations. A module called `OrganizationScope` is included in models that are scoped to an organization. A helper method `current_organization` is defined in the application controller by the `current_user.organization`.

#### Users

Currently, an organization can have users of two roles - `admin` and `user`. The `admin` role has the ability to perform additional actions such as managing users and measurement types for an organization.


#### Row level security

The application makes use of row level security to protect each organizations data in the reporting interface. The technical process for applying and updating the row level security can be found [here](https://github.com/rubyforgood/abalone/wiki/Abalone-Analytics-Blazer-Reporting). The application has a rake task in place that handles the SQL commands needed. This task is updated when new tables that should be included in row level security or made available to an org_user are added.

#### Other models

Currently, the following models access organization directly. This is a design decision that is currently being discussed.

```
  users
  cohorts
  enclosures
  measurements
  measurement_events
  operations
  facilities
  animals
```

### Data Import

There are two primary paths for importing data into the system.  

The first is through the File Upload interface. This allows users to import csv files containing measurement data. Organizations can enter custom measurement types, for example, `mm`, `count`, `gonad_score`. In the future, addition categories beyound `measurement` could be added to this interface. Organizations can upload existing files or download a template file that they can populate.

The second is through the CSV Upload path available on certain index pages. These allow users to import model specific csv files such as a file of basic animal data. These are are likely to be used when onboarding an organization.


### Reporting

Reporting is primarily done through the [Blazer gem](https://github.com/ankane/blazer). There a still commented out uses of the [Reports Kit gem] (https://www.reportskit.co/) in the application. This was considered as an early option for generating reports and may still be used for requested reports that require customization not available through Blazer.


***

__This document was inspired by the Application Overview document from the [Human Essentials](https://github.com/rubyforgood/human-essentials) project__