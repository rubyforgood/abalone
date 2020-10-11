# Overrides the blazer gem's database connection to use
# a custom one based on the logged-in user's organzation.
# This restricts organizations to their own data.
#
# Setup Steps:
# 1. blazer.yml should have one of these entries for
#    each organization's id.
#
#    data_sources:
#      org1:
#        <<: *main
#        url: <%= ENV["ORG1_DATABASE_URL"] %>
#
#    Each organization should inherit from the _main_
#    data_source and provide it's own distinct _url_.
#
#    Example:
#    ORG1_DATABASE_URL="postgres://org1:supersecret@localhost:54321/abalone_development"
#
#    In the URL, _org1_ is the expected user for organization.id == 1.
#    The database name at the end is important because blazer allows
#    you to connect to any db, not just the one powering this rails app.
#
# 2. When adding a new organization, you'll need to add a new
#    postgres user for the orginization before they'd be able
#    to use blazer. Plus adding appropriate policies.
#
#    There are two rake tasks to help with that. See blazer.rake
#    for more info.
#    - rake blazer:add_database_security
#    - rake blazer:drop_databsase_security

unless defined?(Blazer)
  # Blazer is typically loaded by this point so this is for safety.
  # Otherwise, you get reload warnings.
  require_dependency Blazer::Engine.config.root.join('lib', 'blazer').to_s
end

module Blazer
  class << self
    def data_sources
      user_data_source = "org#{Current.user.organization_id}" if Current.user.present?

      ds = Hash.new { |_hash, key| raise Blazer::Error, "Unknown data source: #{key}" }
      settings['data_sources'].each do |id, s|
        ds[id] = Blazer::DataSource.new(id, s)
      end

      # Note that security for blazer requires an organization_id,
      # but if we lifted that requirement, users without an org
      # associated with them would see *all* blazer data_sources.
      if user_data_source
        ds['main'] = ds[user_data_source]
        # Delete other organization sources so they don't
        # appear in blazer's dropdown list.
        ds.delete_if { |k, _v| k != 'main' && k != user_data_source }
      end
      ds
    end
  end
end
