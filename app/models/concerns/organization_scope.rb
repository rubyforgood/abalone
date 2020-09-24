module OrganizationScope
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    scope :for_organization, ->(organization) { where(organization: organization) }
  end
end
