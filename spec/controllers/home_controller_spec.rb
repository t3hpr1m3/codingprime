require 'spec_helper'

describe HomeController, 'as guest' do

  describe 'index' do
    before( :each ) do
      get :index, :subdomains => ['www']
    end
    it { should redirect_to( blog_root_url ) }
  end
end
