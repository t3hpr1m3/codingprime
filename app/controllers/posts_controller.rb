class PostsController < ApplicationController
	before_filter :authorize, :except => [:index, :show]
	# GET /posts
	# GEt /posts.xml
	def index
		@posts = Post.all

		respond_to do |format|
			format.html #index.html.erb
			format.xml { render :xml => @posts }
		end
	end

	# GET /posts/1
	# GET /posts/1.xml
	def show
		@post = Post.find_by_slug( params[:slug] )
		if @post
			@title = @post.title
		end
		#@post = Post.find( params[:id] )

		respond_to do |format|
			format.html # show.html.erb
			format.xml { render :xml => @post }
		end
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

	def edit
		@post = Post.find( params[:id] )
	end

	# POST /posts
	# POST /post.xml
	def create
		@post = Post.new( params[:post] )
		respond_to do |format|
			if @post.save
				flash[:notice] = 'Post was successfully created.'
				format.html { redirect_to( @post ) }
				format.xml { render :xml => @post, :status => :created, :location => @post }
			else
				format.html { render :action => "new" }
				format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /posts/1
	# PUT /posts/1.xml
	def update
		@post = Post.find( params[:id] )

		respond_to do |format|
			if @post.update_attributes( params[:post] )
				flash[:notice] = 'Post was successfully updated.'
				format.html { redirect_to( @post ) }
				format.xml { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /posts/1
	# DELETE /posts/1.xml
	def destroy
		@post = Post.find( params[:id] )
		@post.delete

		respond_to do |format|
			format.html { redirect_to( posts_url ) }
			format.xml { head :ok }
		end
	end

	private
		def authenticate
			authenticate_or_request_with_http_basic do |name, password|
				name == "admin" && password == "secure"
			end
		end

end
