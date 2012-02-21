require 'spec_helper'

describe HomeController, 'as guest' do

  describe 'index' do
    before { get :index }
    it { should redirect_to root_url(:subdomain => 'blog') }
  end
end
