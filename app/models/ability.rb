class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :mark_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down revote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :reset_vote, [Question, Answer] do |resource|
      user.author_of?(resource)
    end

    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }

    can :create,  Subscription
    can :destroy, Subscription, user_id: user.id
  end
end
