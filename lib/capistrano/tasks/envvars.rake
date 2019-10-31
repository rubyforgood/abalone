# frozen_string_literal: true

namespace :envvars do
  desc 'Load environment variables'
  task :load do
    # Grab the current value of :default_env
    environment = fetch(:default_env, {})

    on roles(:app) do
      # Read in the environment file
      lines = capture("cat #{fetch(:deploy_to)}/.environment")
      lines.each_line do |line|
        # Remove the "export " keyword, we have no use for that here
        line = line.sub /^export /, ''
        # Clean up the input by removing line breaks, tabs etc
        line = line.gsub /[\t\r\n\f]+/, ''

        # Grab the key and value from the line
        key, value = line.split('=')

        # Remove surrounding quotes if present
        value = value.slice(1..-2) if value.start_with?('"') && value.end_with?('"')

        # Store the value in our :default_env copy
        environment.store(key, value)
      end

      # Finally, update the global :default_env variable again
      set :default_env, environment
    end
  end
end
