class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, :polymorphic => true, 
                      :foreign_type => "object_type",
                      :foreign_key => "object_id"

  CATEGORIES = [
                :auth,
               ]

  class << self
    def login(user)
      add(:auth, user, "auth.login")
    end

    def logout(user)
      add(:auth, user, "auth.logout")
    end

    private
    def add(category, user, description, obj = nil)
      act = self.new

      act.category = category.to_s
      act.user_id = user.id if user
      act.description = description
      if obj
        obj.linked_activities << act
      else
        act.save
      end
    end
  end
end
