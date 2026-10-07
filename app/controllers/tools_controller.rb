class ToolsController < ApplicationController
  before_action :load_tool, only: :show

  def index
    @tools = ToolCatalog.all
    @saved_slugs = current_user&.saved_tools&.pluck(:slug) || []
  end

  def show
    @tools = ToolCatalog.all
    @saved_slugs = current_user&.saved_tools&.pluck(:slug) || []
  end

  private

  def load_tool
    @tool = ToolCatalog.find(params[:slug])
    redirect_to root_path, alert: "そのツールは見つかりませんでした。" unless @tool
  end
end
