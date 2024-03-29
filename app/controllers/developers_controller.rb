class DevelopersController < ApplicationController
  helper_method :posts, :developer

  def update
    if developer.update(developer_params)
      redirect_to root_path, notice: "Developer updated"
    else
      render :edit, status: 422
    end
  end

  private

  def posts
    @posts ||= developer.posts.published_and_ordered.includes(:channel)
  end

  def developer
    @developer ||= if params[:action] == "show"
      Developer.find_by_username!(params[:id])
    else
      current_developer
    end
  end

  def developer_params
    params.require(:developer).permit(:editor, :twitter_handle, :slack_name)
  end
end
