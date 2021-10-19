class Ability
  # Add in CanCan's ability definition DSL
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can %i[show destroy index], ProcessedFile, organization_id: user.organization_id

    [
      Animal,
      Cohort,
      Enclosure,
      ExitType,
      Facility,
      MeasurementType,
      User
    ].each do |model|
      can :manage, model, organization_id: user.organization_id
    end
  end
end
