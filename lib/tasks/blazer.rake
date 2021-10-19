# frozen_string_literal: true

# Add/Drop Postgres users for each organization
# with read-only permission and row-level security
# policies restricting them to only their organization
# data for tables containing an `organization_id` column.
#
# Usage:
# rake blazer:add_database_security
# rake blazer:drop_database_security
#
# By default, they will simply echo out a SQL script
# you can use to execute manually if you like.
#
# Add `SAVE=1` and they will execute against the
# Rails environment's database.

# There is a row level security gem which could
# potentially be used to make the SQL code here
# more ruby-like. https://github.com/suus-io/rls_rails

namespace :blazer do
  desc 'Add Blazer db security for all organizations'
  task add_database_security: :environment do
    check_blazer_config

    # read-only users per organization
    Organization.all.each do |org|
      run_query create_organization_user(org)
    end

    # policies to restrict organizations to their own data
    db_connection.tables.each do |table|
      if db_connection.columns(table).map(&:name).include?("organization_id")
        run_query policy_sql(table)
      end
    end
  end

  desc 'Remove Blazer db security for organizations'
  task drop_database_security: :environment do
    check_blazer_config

    # policies to restrict organizations to their own data
    db_connection.tables.each do |table|
      if db_connection.columns(table).map(&:name).include?("organization_id")
        run_query drop_policy_sql(table)
      end
    end

    # read-only users per organization
    Organization.all.each do |org|
      run_query drop_organization_user(org)
    end
  end

  private

  def saving?
    ENV['SAVE']
  end

  # Does blazer.yml contain a user for all organizations?
  # We can't create a postgres user otherwise.
  def check_blazer_config
    orgs = Organization.ids.map { |id| "org#{id}".to_sym }
    blazer_orgs = blazer_config[:data_sources].keys - [:main]

    missing_orgs = orgs - blazer_orgs
    return if missing_orgs.empty?

    puts <<~MESSAGE
      [ERROR] Missing user#{'s' if missing_orgs.size > 1} from config/blazer.yml file:
      -> #{missing_orgs.join("\n- ")}
    MESSAGE
    exit
  end

  # This follows the recommended SQL from [blazer's docs](https://github.com/ankane/blazer#postgresql)
  def create_organization_user(org)
    org_user = "org#{org.id}"

    # This conditional accommodates the current hosting environment which requires the role to be set up separately.
    if Rails.env.production?
      <<~SQL
        BEGIN;
        GRANT CONNECT ON DATABASE #{db_connection.current_database} TO #{org_user};
        GRANT USAGE ON SCHEMA public TO #{org_user};
        GRANT SELECT ON TABLE animals TO #{org_user};
        GRANT SELECT ON TABLE cohorts TO #{org_user};
        GRANT SELECT ON TABLE enclosures TO #{org_user};
        GRANT SELECT ON TABLE facilities TO #{org_user};
        GRANT SELECT ON TABLE locations TO #{org_user};
        GRANT SELECT ON TABLE measurement_events TO #{org_user};
        GRANT SELECT ON TABLE measurement_types TO #{org_user};
        GRANT SELECT ON TABLE measurements TO #{org_user};
        GRANT SELECT ON TABLE mortality_events TO #{org_user};
        GRANT SELECT ON TABLE operations TO #{org_user};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO #{org_user};
        COMMIT;
      SQL
    else
      <<~SQL
        BEGIN;
        CREATE ROLE #{org_user} LOGIN PASSWORD '#{org_db_password(org)}';
        GRANT CONNECT ON DATABASE #{db_connection.current_database} TO #{org_user};
        GRANT USAGE ON SCHEMA public TO #{org_user};
        GRANT SELECT ON TABLE animals TO #{org_user};
        GRANT SELECT ON TABLE cohorts TO #{org_user};
        GRANT SELECT ON TABLE enclosures TO #{org_user};
        GRANT SELECT ON TABLE facilities TO #{org_user};
        GRANT SELECT ON TABLE locations TO #{org_user};
        GRANT SELECT ON TABLE measurement_events TO #{org_user};
        GRANT SELECT ON TABLE measurement_types TO #{org_user};
        GRANT SELECT ON TABLE measurements TO #{org_user};
        GRANT SELECT ON TABLE mortality_events TO #{org_user};
        GRANT SELECT ON TABLE operations TO #{org_user};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO #{org_user};
        COMMIT;
      SQL
    end
  end

  def drop_organization_user(org)
    org_user = "org#{org.id}"

    # This conditional accommodates the current hosting environment which requires the role to be dropped separately.
    if Rails.env.production?
      <<~SQL
        DROP OWNED BY #{org_user};
      SQL
    else
      <<~SQL
        DROP OWNED BY #{org_user};
        DROP ROLE #{org_user};
      SQL
    end
  end

  def policy_sql(table)
    <<~SQL
      ALTER TABLE #{table} ENABLE ROW LEVEL SECURITY;
      CREATE POLICY org_policy ON #{table}
      FOR SELECT
      TO public
      USING (CASE #{policy_case_conditions}
             END);
    SQL
  end

  def drop_policy_sql(table)
    <<~SQL
      ALTER TABLE #{table} DISABLE ROW LEVEL SECURITY;
      DROP POLICY org_policy ON #{table};
    SQL
  end

  def policy_case_conditions
    Organization.ids.map do |id|
      "WHEN CURRENT_USER = 'org#{id}' THEN organization_id = #{id}"
    end.join("\n            ")
  end

  def db_connection
    ActiveRecord::Base.connection
  end

  def run_query(sql)
    if saving?
      db_connection.execute(sql)
    else
      puts "#{sql}\n"
    end
  rescue StandardError => e
    # May only want to ignore exceptions when we drop things because
    # an error dropping something not there doesn't matter.
    puts e.message
  end

  # This assumes blazer.yml stores full user db connections.
  # Ex: postgres://org1:password@dbserver:54321
  def org_db_password(org)
    org_user = "org#{org.id}".to_sym
    db_url = blazer_config.dig(:data_sources, org_user, :url)
    db_url.match(/#{org_user}:([^@]+)/)[1]
  end

  def blazer_config
    @blazer_config ||= YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'blazer.yml'))).result, aliases: true).deep_symbolize_keys
  end
end
