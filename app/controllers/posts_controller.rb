class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  before_action :require_developer, except: [:index, :show, :like, :unlike, :random]
  before_action :authorize_developer, only: [:edit, :update]

  helper_method :post

  def preview
    render layout: false
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.developer = current_developer
    if @post.save
      path = process_post
      redirect_to path, notice: display_name(@post) + "created"
    else
      render :new, status: 422
    end
  end

  def index
    @posts = posts_with_developer_and_channel.published_and_ordered.search(params[:q])

    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.atom
    end
  end

  def random
    @post = Post.order("random()").first
    render template: "posts/show"
  end

  def show
    if valid_url?
      respond_to do |format|
        format.html
        format.md { response.headers["X-Robots-Tag"] = "noindex" }
        format.json { render json: @post }
      end
    else
      redirect_to_valid_slug
    end
  end

  def edit
    redirect_to edit_post_path @post unless valid_url?
  end

  def update
    if @post.update(post_params)
      @post.publish if params[:published] && !@post.published?
      SocialMessaging::TwitterStatus.new(@post).post_to_twitter
      redirect_to @post, notice: display_name(@post) + "updated"
    else
      render :edit, status: 422
    end
  end

  def sorted_channels
    Channel.order name: :asc
  end
  helper_method :sorted_channels

  def like
    post = Post.find(params[:id])
    cookies.encrypted[post.id.to_s] = {value: true, expires_at: 1.year.from_now}

    respond_to do |format|
      if post.increment_likes
        format.json { render json: {likes: post.likes} }
        format.html { redirect_to post }
      end
    end
  end

  def unlike
    post = Post.find(params[:id])
    return if cookies.encrypted[post.id.to_s] != true

    cookies.delete(post.id.to_s)
    respond_to do |format|
      if post.decrement_likes
        format.json { render json: {likes: post.likes} }
        format.html { redirect_to post }
      end
    end
  end

  def drafts
    @posts = posts_with_developer_and_channel.drafts

    unless current_developer.admin?
      @posts = @posts.where(developer: current_developer)
    end

    render :index
  end

  private

  attr_reader :post

  def process_post
    if params[:published]
      @post.publish
      SocialMessaging::TwitterStatus.new(@post).post_to_twitter
      root_path
    else
      drafts_path
    end
  end

  def posts_with_developer_and_channel
    Post.includes(:developer, :channel).page(params[:page]).per(50)
  end

  def redirect_to_valid_slug
    respond_to do |format|
      format.md { redirect_to post_text_path(@post) }
      format.html { redirect_to @post }
    end
  end

  def post_params
    params.require(:post).permit :body, :channel_id, :title
  end

  def untitled_slug
    params[:titled_slug].split("-").first
  end

  def set_post
    @post = Post.includes(:developer).find_by_slug!(untitled_slug)
  end

  def authorize_developer
    unless editable?(@post)
      redirect_to root_path, alert: "You can only edit your own posts"
    end
  end

  def valid_url?
    @post.to_param == params[:titled_slug]
  end

  def display_name(post)
    post.published? ? "Post " : "Draft "
  end
end
