module ActivityHelper

  def description(activity)
    tag = "activity.descriptions.#{activity.description}"
    params = activity.params || {}
    params[:default] = activity.description + ":" + params.inspect

    begin
      h(t(tag, params))
    rescue
      h(params[:default])
    end
  end

  def category(activity)
    tag = "activity.categories.#{activity.category}"
    h(t(tag, :default => activity.category))
  end
  
end
