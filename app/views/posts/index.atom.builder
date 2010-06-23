atom_feed do |feed|
  feed.title( "codingPrime" )
  feed.updated( @posts.first.created_at )

  @posts.each do |post|
    feed.entry( post ) do |entry|
      entry.title( post.title )
      #entry.content( render_markdown( post.body ), :type => 'html' )
      entry.content :type => 'html' do |c|
        c.cdata!( render_text( post.body, :escape_harsh => true ).join )
      end
      entry.author do |author|
        author.name( post.user.name )
        author.uri( root_url )
      end
    end
  end
end
