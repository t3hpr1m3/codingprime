class CommentsController < ApplicationController
  before_filter(:get_post)

  # GET /comments
  # GET /comments.xml
  def index
    @approved_comments = Comment.recent( 20, :approved => true )
    @rejected_comments = Comment.recent( 20, :approved => false ) if admin?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = @post.comments.find( params[:id] )
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @post.comments.build( params[:comment] )
	@comment.request = request

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
	  	flash[:error] = 'Error saving comment.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = @post.comments.find( params[:id] )

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @post.comments.find( params[:id] )
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to( comments_url( @post ) ) }
      format.xml  { head :ok }
    end
  end

  private
  def get_post
    @post = Post.find( params[:post_id] )
  end
end