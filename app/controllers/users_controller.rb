class UsersController < ApplicationController
	before_filter :authorize
	# GET /users
	# GET /users.xml
	def index
		@users = User.all

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @users }
		end
	end

	# GET /users/1
	# GET /users/1.xml
	def show
		@user = User.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml	{ render :xml => @user }
		end
	end

	# GET /users/new
	# GET /users/new.xml
	def new
		@user = User.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @user }
		end
	end

	# GET /users/1/edit
	def edit
		@user = User.find(params[:id])
	end

	# POST /users
	# POST /users.xml
	def create
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
				flash[:notice] = 'User was successfully created.'
				format.html { redirect_to( users_path ) }
				format.xml	{ render :xml => @user, :status => :created, :location => @user }
			else
				flash.now[:error] = 'Error creating user.'
				format.html { render :action => "new" }
				format.xml	{ render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.xml
	def update
		@user = User.find( params[:id] )

		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash[:notice] = 'User was successfully updated.'
				format.html { redirect_to( users_path ) }
				format.xml	{ head :ok }
			else
				flash.now[:error] = 'Unable to create user.'
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.xml
	def destroy
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			flash[:notice] = 'User deleted.'
			format.html { redirect_to( users_path ) }
			format.xml	{ head :ok }
		end
	end
end
