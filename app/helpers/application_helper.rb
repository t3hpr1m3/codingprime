module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def render_text(text)
    markdown(coderay(text))
  end
  def coderay(text, options = {})
    text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      CodeRay.scan($3, $2).div(:css => :class)
    end
  end

  def markdown(text, options = {})
    RDiscount.new(text.strip).to_html
  end
end
