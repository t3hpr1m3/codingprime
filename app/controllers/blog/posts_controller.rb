class Blog::PostsController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :show_by_slug]
  before_filter :get_post_by_slug, :only => [:show_by_slug]
  before_filter :get_post, :only => [:show, :edit, :update, :destroy]

  def index
    @posts = Post.recent
    respond_to do |format|
      format.html { @posts = @posts.paginate( :page => params[:page], :per_page => 5 ) }
      format.xml { render :xml => @posts }
      format.atom
      format.json { render :json => @posts }
    end
  end

  def show_by_slug
    @title = @post.title
    @comment = Comment.new( :post => @post )

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml { render :xml => @post }
    end
  end

  def show
    redirect_to @post.url, :status => 301
  end

  def new
    @post = current_user.posts.build

    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
    end
  end

  def create
    @post = current_user.posts.build(params[:post])

    if params[:preview_button]
      respond_to do |format|
        format.html { render :preview }
        format.xml
      end
    else
      respond_to do |format|
        if @post.save
          format.html { redirect_to @post.url, :notice => 'Post created successfully.' }
          format.xml { render :xml => @post, :status => :created, :location => @post }
        else
          format.html { render :new }
          format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
  end

  def update
    if params[:preview_button]
      @post.attributes = params[:post]
      respond_to do |format|
        format.html { render :preview }
      end
    else
      respond_to do |format|
        if @post.update_attributes(params[:post])
          format.html { redirect_to @post.url, :notice => 'Post was successfully updated.' }
          format.xml { head :ok }
        else
          format.html { render :edit }
          format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_url(:subdomain => request.subdomain), :notice => 'Post deleted.' }
      format.xml { head :ok }
    end
  end

  private

  def get_post_by_slug
    @post = Post.find_by_slug( params[:slug] )
    raise ActiveRecord::RecordNotFound if @post.nil?
  end

  def get_post
    @post = Post.find( params[:id] )
  end
end
