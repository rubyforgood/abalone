module OrganizationScope
  extend ActiveSupport::Concern
  include ReportsKit::Model

  included do
    belongs_to :organization

    scope :for_organization, ->(organization) { where(organization: organization) }

    reports_kit do
      contextual_filter :for_organization, ->(relation, context_params){
        relation.for_organization(context_params[:organization_id])
      }
    end
  end
end
