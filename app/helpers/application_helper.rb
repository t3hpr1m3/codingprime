# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    base_title = "CodingPrime"
    if @title.nil? or @title.length.eql? 0
      base_title
    else
      "#{base_title} :: #{@title}"
    end
  end


  def render_text( text, options = {} )
    text_pieces = text.split(/(<code>|<code lang="[A-Za-z0-9_-]+">|
      <code lang='[A-Za-z0-9_-]+'>|<\/code>)/)
    in_pre = false
    language = nil
    output = ""
    text_pieces.collect do |piece|
      if piece =~ /^<code( lang=(["'])?(.*)\2)?>$/
        language = $3
        in_pre = true
        nil
      elsif piece == "</code>"
        in_pre = false
        language = nil
        nil
      elsif in_pre
        if options[:escape_harsh]
          "<pre>" + h( piece.strip ) + "</pre>"
        else
          lang = language ? language : "ruby"
          harsh( piece.strip, { :format => lang, :theme => "spacecadet" } )
        end
      else
        render_markdown( piece, options )
      end
    end
  end

  def render_markdown( text, options = {} )
    if options[:strip]
      RDiscount.new( strip_tags( text.strip ) ).to_html
    else
      RDiscount.new( text.strip ).to_html
    end
  end
end
