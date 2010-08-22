class Blog::CommentsController < ApplicationController
  before_filter :authorize, :only => [:edit, :update, :destroy]

  # GET /comments
  # GET /comments.xml
  def index
    @approved_comments = Comment.valid
    @rejected_comments = Comment.rejected if admin?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    flash[:notice] = 'To add a comment, please visit a post.'
    redirect_to blog_root_url
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find( params[:id] )
    raise ActiveRecord::RecordNotFound if @comment.nil?
    respond_to do |format|
      format.html
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new( params[:comment] )
	@comment.request = request

    if params[:preview_button]
      @preview = true
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml
      end
    else
      respond_to do |format|
        if @comment.save
          flash[:notice] = 'Comment was successfully created.'
          format.html { redirect_to @comment.post.url }
          format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        else
          flash[:error] = 'Error saving comment.'
          format.html { render :action => "new" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find( params[:id] )

    respond_to do |format|
      if params[:preview]
        @preview = true
        @comment.attributes = params[:comment]
        format.html { render :action => "edit" }
      else
        if @comment.update_attributes(params[:comment])
          flash[:notice] = 'Comment was successfully updated.'
          format.html { redirect_to(@comment.post.url) }
          format.xml  { head :ok }
        else
          flash[:error] = 'Error saving comment.'
          format.html { render :action => "edit" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find( params[:id] )
    @post = @comment.post
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @post.url }
      format.xml  { head :ok }
    end
  end
end
