# The activity controller contains the following actions:
# [#index]   the default action, redirects to list
# [#list]    list all the activities
class ActivityController < ApplicationController
  before_filter :authorize_admin # this should only be accessible for admins

  # The default action, redirects to list.
  def index
    list
    render :action => 'list'
  end

  def list
    @activities = Activity.find(:all, :order => 'id desc')
  end
end
