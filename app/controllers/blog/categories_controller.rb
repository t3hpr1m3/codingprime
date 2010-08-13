class Blog::CategoriesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_category_by_slug, :except => [:index, :new, :create]

  def get_category_by_slug
    @category = Category.find_by_slug( params[:id] )
    raise ActiveRecord::RecordNotFound if @category.nil?
  end

  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @title = @category.name
    @posts = @category.posts

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @category }
      format.json { render :json => @category }
    end
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new( params[:category] )

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to( [:blog, @category] ) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        flash.now[:error] = 'There was an error saving your category.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to( [:blog, @category] ) }
        format.xml  { head :ok }
      else
        flash.now[:error] = 'There was an error saving your category.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      flash[:notice] = "Category deleted successfully."
      format.html { redirect_to( blog_root_path ) }
      format.xml  { head :ok }
    end
  end
end