class AccountController < ApplicationController
  before_action :require_authentication

  def show
    @saved_tools = current_user.saved_tools.order(created_at: :desc)
    @recent_histories = current_user.tool_histories.order(created_at: :desc).limit(8)
    @tools = ToolCatalog.all
  end
end
