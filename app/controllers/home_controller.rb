class HomeController < ApplicationController
  def index
    @posts = Post.all
    respond_to do |format|
      format.html
      format.atom
    end
  end
end
