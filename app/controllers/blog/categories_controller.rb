class Blog::CategoriesController < ApplicationController
  before_filter :authorize, :except => [:index, :show]
  before_filter :get_category_by_slug, :except => [:index, :new, :create]

  respond_to :html, :xml, :json

  def index
    @categories = Category.all
    respond_with(:blog, @categories)
  end

  def show
    @title = @category.name
    @posts = @category.posts.recent

    respond_with(:blog, @category) do |format|
      format.html { @posts = @posts.paginate(page: params[:page], per_page: 5 ) }
    end
  end

  def new
    @category = Category.new
    respond_with(:blog, @category)
  end

  def create
    @category = Category.new(params[:category])
    flash.notice = 'Category was successfully created.' if @category.save
    respond_with(:blog, @category)
  end

  def edit
    respond_with(:blog, @category)
  end

  def update
    flash[:notice] = 'Category was successfully updated.' if @category.update_attributes(params[:category])
    respond_with(:blog, @category)
  end

  def destroy
    if @category.destroy
      flash.notice = 'Category deleted successfully.'
    else
      flash.alert = @category.errors.full_messages.join("\n")
    end
    respond_with(:blog, @category)
  end

  private

  def get_category_by_slug
    @category = Category.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound if @category.nil?
  end
end
