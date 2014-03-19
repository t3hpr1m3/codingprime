require 'spec_helper'

describe ApplicationHelper do
  describe 'title' do
    it 'should set the content_for :title' do
      expect(helper).to receive(:content_for).with(:title)
      helper.title('Cool Page')
    end
  end

  describe "render_text" do
    describe "with plain text" do
      specify { expect(helper.render_text('plain_text')).to eql("<p>plain_text</p>\n") }
    end

    #describe "with code chunk" do
    #  it "should render properly" do
    #    helper.render_text( "<code>foo</code>" ).should eql( ["\n", nil, "<pre class=\"#{::AppConfig.harsh_theme}\">foo\n</pre>", nil] )
    #  end
    #end
  end
end
