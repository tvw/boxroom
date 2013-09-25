module ActivityHelper

  def description(activity)
    tag = "activity.descriptions.#{activity.description}"
    h(t(tag, :default => activity.description))
  end

  def category(activity)
    tag = "activity.categories.#{activity.category}"
    h(t(tag, :default => activity.category))
  end
  
end
