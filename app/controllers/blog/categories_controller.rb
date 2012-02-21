class Blog::CategoriesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_category_by_slug, :except => [:index, :new, :create]

  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end
  def show
    @title = @category.name
    @posts = @category.posts.recent

    respond_to do |format|
      format.html { @posts = @posts.paginate( :page => params[:page], :per_page => 5 ) }
      format.xml  { render :xml => @category }
    end
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @category }
      format.json { render :json => @category }
    end
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, :notice => 'Category was successfully created.' }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :new }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, :notice => 'Category was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :edit }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to root_url(:subdomain => 'blog'), :notice => 'Category deleted successfully.' }
      format.xml  { head :ok }
    end
  end

  private

  def get_category_by_slug
    @category = Category.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound if @category.nil?
  end
end
