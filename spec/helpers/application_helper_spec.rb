require 'spec_helper'

describe ApplicationHelper do
  describe "page_title" do
    describe "with a nil title" do
      it "should be CodingPrime" do
        helper.instance_variable_set '@title', nil
        helper.page_title.should eql( "CodingPrime" )
      end
    end

    describe "with 'Contact' for title" do
      it "should be CodingPrime :: Contact" do
        helper.instance_variable_set '@title', 'Contact'
        helper.page_title.should eql( "CodingPrime :: Contact" )
      end
    end
  end

  describe "render_text" do
    describe "with plain text" do
      it "should be plain_text" do
        helper.render_text( "plain_text" ).should eql( ["<p>plain_text</p>\n"] )
      end
    end

    describe "with code chunk" do
      it "should render properly" do
        helper.render_text( "<code>foo</code>" ).should eql( ["\n", nil, "<pre class=\"#{::AppConfig.harsh_theme}\">foo\n</pre>", nil] )
      end
    end
  end
end
