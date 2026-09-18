class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == "admin"
      can :manage, Subject
      can :manage, Topic
      can :manage, Lesson
      can :manage, Activity
    else
      can :read, Subject
      can :read, Topic
      can :read, Lesson
      can :read, Activity
    end
  end
end
