class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, Subject
      can :manage, Topic
    elsif user.student?
      can :read, Subject
      can :read, Topic
    end
  end
end
