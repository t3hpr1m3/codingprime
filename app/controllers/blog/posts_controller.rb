class Blog::PostsController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :show_by_slug]
  before_filter :get_post_by_slug, :only => [:show_by_slug]
  before_filter :get_post, :only => [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    @posts = Post.recent
    respond_with @posts do |format|
      format.html { @posts = @posts.paginate(page: params[:page], per_page: 5) }
      format.atom
    end
  end

  def show_by_slug
    @title = @post.title
    @comment = Comment.new(post: @post)
    respond_with @comment do |format|
      format.html { render :show }
    end
  end

  def show
    redirect_to @post.url, status: 301
  end

  def new
    @post = current_user.posts.build
    respond_with @post
  end

  def create
    @post = current_user.posts.build(post_params)

    if params[:preview_button]
      respond_to do |format|
        format.html { render :preview }
      end
    else
      if @post.save
        flash.notice = 'Post created successfully.'
        respond_with @post, location: blog_post_by_slug_url(@post.slug_options)
      else
        respond_with @post
      end
    end
  end

  def edit
    respond_with @post
  end

  def update
    if params[:preview_button]
      @post.attributes = post_params
      respond_to do |format|
        format.html { render :preview }
      end
    else
      flash.notice = 'Post was successfully updated.' if @post.update_attributes(post_params)
      respond_with @post, location: blog_post_by_slug_url(@post.slug_options)
    end
  end

  def destroy
    @post.destroy
    flash.notice = 'Post deleted.'
    respond_with @post, location: root_url
  end

  private

  def get_post_by_slug
    @post = Post.find_by_slug( params[:slug] )
    raise ActiveRecord::RecordNotFound if @post.nil?
  end

  def get_post
    @post = Post.find( params[:id] )
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
