class Ability
  # Add in CanCan's ability definition DSL
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :same_organization, Animal do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, Cohort do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, Enclosure do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, ExitType do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, Facility do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, ProcessedFile do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, MeasurementType do |item|
      item.organization_id == user.organization_id
    end

    can :same_organization, User do |item|
      item.organization_id == user.organization_id
    end
  end
end
