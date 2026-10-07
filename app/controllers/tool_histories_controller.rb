class ToolHistoriesController < ApplicationController
  before_action :require_authentication

  def create
    tool = ToolCatalog.find(params[:slug])
    return render json: { error: "tool_not_found" }, status: :not_found unless tool

    history = current_user.tool_histories.create!(slug: tool[:slug], input_preview: params[:input_preview].to_s.truncate(500))
    render json: { id: history.id, message: "saved" }, status: :created
  end
end
