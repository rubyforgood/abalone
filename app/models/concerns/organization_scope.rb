module OrganizationScope
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    scope :for_organization, ->(organization_id) { where(organization_id: organization_id) }
  end
end
