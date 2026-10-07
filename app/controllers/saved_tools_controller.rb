class SavedToolsController < ApplicationController
  before_action :require_authentication

  def create
    tool = ToolCatalog.find(params[:slug])
    return redirect_to root_path, alert: "そのツールは見つかりませんでした。" unless tool

    current_user.saved_tools.find_or_create_by!(slug: tool[:slug])
    redirect_back fallback_location: root_path, notice: "#{tool[:name]}をお気に入りに追加しました。"
  end

  def destroy
    saved_tool = current_user.saved_tools.find_by(slug: params[:slug])
    saved_tool&.destroy
    redirect_back fallback_location: root_path, notice: "お気に入りから外しました。"
  end
end
