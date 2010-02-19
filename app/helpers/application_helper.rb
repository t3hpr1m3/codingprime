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
        lang = language ? language : "ruby"
        logger.debug( "lang => #{lang}" )
        harsh(piece.strip, { :format => lang, :theme => "spacecadet" } )
      else
        concat( markdown( piece, options ) )
      end
    end
    ""
  end

  def markdown( text, options = {} )
    if options[:strip]
      RDiscount.new( strip_tags( text.strip ) ).to_html
    else
      RDiscount.new( text.strip ).to_html
    end
  end
end
