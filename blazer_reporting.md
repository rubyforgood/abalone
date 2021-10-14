## Abalone Analytics Blazer Reporting

This application utilizes a modified implementation of the [Blazer](https://github.com/ankane/blazer) gem to provide direct SQL access to specific tables with data scoped to an organizational level. Modifications to the Blazer gem are performed in app/overrides directories per [Rails documented practices](https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers). The Blazer gem version has been locked at 2.4.7 to ensure these overrides remain dependable.

Use of the Blazer gem requires setup in both the production and development environments.

### Production Environment

#### Initial Setup

This setup assumes Heroku hosting. Guidance for setup on other hosting platforms is welcome via PR. The maintainers will also update this document as the application evolves.

Note: Requires, at least, a Standard-0 Postgres instance in Heroku to allow for the creation of additional roles.

Note: For consistency, each org credential should be named with that organization's ID. Example: `org7`

1. Ensure that the initial set of organizations have been setup in the application. Each entry should be present in the database and should have an entry in the `blazer.yml` file.
   ```text
    org1:
    <<: *main
    url: <%= ENV["ORG1_DATABASE_URL"] %>
   ```
2. In Heroku, add a credential named `blazer`.
3. Attach that credential to the application.
4. Set permissions to `Read-only`.
5. Create a credential named `org1` (assuming an organization with an ID of 1).
6. Attach that credential to the application.
7. Leave the permissions blank. They will be set by the Blazer rake task.
8. Repeat steps 5-7 for each organization in the application.
9. In Heroku, add the environment variables for the blazer credential and all org credentials. The urls will be available under each credential in the Postgres add-on.
    `BLAZER_DATABASE_URL: add credential uri here`
    `ORG1_DATABASE_URL: add credential uri here`
    `ORG2_DATABASE_URL: add credential uri here`
10. Run a backup of the production database
11. Run the Blazer rake task: `heroku run SAVE=1 rake blazer:add_database_security`.
12. Log in as an organization user and confirm reporting is now functioning and scoped.

#### Adding a New organization

1. Add the organization to the application (database and entry in `blazer.yml`)
2. In Heroku, add a credential for that organization: `org#{ID}`.
3. Attach that credential to the application.
4. Leave the permissions blank. They will be set by the Blazer rake task.
5. Add the environment variable for the new credential using the uri available in the Postgres add-on.
    `ORG#{ID}_DATABASE_URL: add credential uri here`
6. Run a backup of the production database
7. Run the Blazer rake task: `heroku run SAVE=1 rake blazer:add_database_security`.
8. Log in as an organization user and confirm reporting is now functioning and scoped.

[](#dev-environment)
### Development Environment

#### Initial Setup

This process assumes initial setup, migration and seeding of a local postgres database as described in the [setup instructions](https://github.com/rubyforgood/abalone/blob/main/README.md).

1. Add the file `config/local_env.yml` (this is covered by the application's .gitignore file)
2. Add the blazer-related environment variables to the `config/local_env.yml` file. These will vary based on your local setup but the pattern provided below should work for most. Replace "password" with your chosen password. Note: A password must be present in the organization urls.
    ```text
    BLAZER_DATABASE_URL: postgres://blazer:password@localhost:5432/abalone_development
    ORG1_DATABASE_URL: postgres://org1:password@localhost:5432/abalone_development
    ORG2_DATABASE_URL: postgres://org2:password@localhost:5432/abalone_development
    ```
3. Ensure that each organization has an entry in the `blazer.yml` file.
   ```text
   org1:
    <<: *main
    url: <%= ENV["ORG1_DATABASE_URL"] %>
   ```
3. Restart your server
4. Run the Blazer rake task: `SAVE=1 bundle exec rake blazer:add_database_security`
5. Log in as an organization user and confirm reporting is now functioning and scoped.

#### Adding a New Organization

1. Add the organization to the application (database and entry in `blazer.yml`)
2. Add a url for the new organization to the `config/local_env.yml` file :
    `ORG#{ID}_DATABASE_URL: postgres://org#{ID}:password@localhost:5432/abalone_development`
3. Restart your server
4. Run the Blazer drop rake task: `SAVE=1 bundle exec rake blazer:drop_database_security`
5. Run the Blazer add rake task: `SAVE=1 bundle exec rake blazer:add_database_security`
6. Log in as a user for the new organization and confirm reporting is now functioning and scoped.

### Tables available for reporting
- animals
- cohorts
- enclosures
- facilities
- locations
- measurement events
- measurement types
- measurements
- mortality events
- operations