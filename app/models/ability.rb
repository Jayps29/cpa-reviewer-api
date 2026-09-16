class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, Subject
    elsif user.student?
      can :read, Subject
    end
  end
end
