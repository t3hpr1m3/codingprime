class PostsController < ApplicationController
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
		@post = Post.find( params[:id] )

		respond_to do |format|
			format.html # show.html.erb
			format.xml { render :xml => @post }
		end
	end

	# GET /posts/new
	# GET /post/new.xml
	def new
	end

	def edit
	end

	def create
	end

	def update
	end

	def destroy
	end

end
