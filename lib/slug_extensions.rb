module SlugExtensions
  def generate_slug( text )
    str = text
    str = str.gsub( /[^a-zA-Z0-9\s]/, "" ).downcase
    str = str.gsub( /[\s]+/, " " )
    str = str.gsub( /\s/, "-" )
    str
  end
end
