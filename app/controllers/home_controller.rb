class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html { redirect_to root_url(:subdomain => 'blog') }
      format.atom
    end
  end
end
