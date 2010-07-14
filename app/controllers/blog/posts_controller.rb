class Blog::PostsController < ApplicationController
  before_filter :authorize, :except => [:index, :show, :show_by_slug]
  before_filter :get_post_by_slug, :except => [:index, :new, :create]

  def get_post_by_slug
    @post = Post.find_by_slug( params[:id] )
    raise ActiveRecord::RecordNotFound if @post.nil?
  end
  # GET /posts
  # GEt /posts.xml
  def index
    @posts = Post.all
    respond_to do |format|
			format.html #index.html.erb
			format.xml { render :xml => @posts }
      format.atom
			format.json { render :json => @posts }
		end
	end

  # GET /2010/02/01/my-post-title
  # GET /2010/02/01/my-post-title.xml
  def show_by_slug
    @title = @post.title

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml { render :xml => @post }
    end
  end

	# GET /posts/1
	# GET /posts/1.xml
	def show
		@post = Post.find( params[:id] )
		redirect_to @post.url, :status => 301
	end

	# GET /posts/new
	# GET /post/new.xml
	def new
		@post = Post.new

		respond_to do |format|
			format.html
			format.xml { render :xml => @post }
		end
	end

    # GET /posts/1/edit
	def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @post }
      format.json { render :json => @post }
    end
	end

	# POST /posts
	# POST /post.xml
	def create
		@post = Post.new( params[:post] )

		if params[:preview_button]
			@preview = true
			respond_to do |format|
				format.html { render :action => "new" }
                format.xml
			end
		else
			@post.user = current_user
			respond_to do |format|
				if @post.save
					flash[:notice] = 'Post created successfully.'
					format.html { redirect_to( @post.url ) }
					format.xml { render :xml => @post, :status => :created, :location => @post }
				else
					flash.now[:error] = 'There was an error saving your post.'
					format.html { render :action => "new" }
					format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
				end
			end
		end
	end

	# PUT /posts/1
	# PUT /posts/1.xml
	def update
		if params[:preview_button]
			@preview = true
            @post.attributes= params[:post]
			#@post.title = params[:post][:title]
			#@post.body = params[:post][:body]
			respond_to do |format|
				format.html { render :action => "edit" }
			end
		else
			respond_to do |format|
				if @post.update_attributes( params[:post] )
					flash[:notice] = 'Post was successfully updated.'
					format.html { redirect_to( @post.url ) }
					format.xml { head :ok }
				else
					flash.now[:notice] = 'Unable to update post'
					format.html { render :action => "edit" }
					format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /posts/1
	# DELETE /posts/1.xml
	def destroy
		@post.delete

		respond_to do |format|
			format.html { redirect_to( posts_url ) }
			format.xml { head :ok }
		end
	end
end
