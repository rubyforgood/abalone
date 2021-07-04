dev_env:
	docker-compose up --detach web delayed_job
	@echo -
	@echo - Services started! Watch development logs with 'make watch'.
	@echo -

minty_fresh: nuke schema_migrate dev_env

watch:
	docker-compose logs --follow web delayed_job

console:
	docker-compose run --rm console

test: spec lint brakeman

spec: schema_migrate
	@echo -
	@echo - Running specs!
	@echo -
	docker-compose run --rm rspec

lint:
	@echo -
	@echo - Running Rubocop!
	@echo -
	docker-compose run --rm rubocop

brakeman:
	@echo -
	@echo - Running Brakeman!
	@echo -
	docker-compose run --rm brakeman 

database_started:
	@echo - Starting up database.
	docker-compose up --detach db

schema_migrate: database_started
	@echo -
	@echo - Applying any pending migrations.
	@echo -
	docker-compose run --rm schema_migrate

schema_status:
	docker-compose run --rm pending_migrations

database_seeds: schema_migrate
	docker-compose run --rm seeds

build:
	docker-compose build app

nuke:
	@echo -
	@echo - Stopping and destroying development services and database.
	@echo -
	docker-compose down --volumes
