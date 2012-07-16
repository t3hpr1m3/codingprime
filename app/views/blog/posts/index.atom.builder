atom_feed do |feed|
  feed.title("codingPrime")
  feed.updated(@posts.first.created_at)

  @posts.each do |post|
    feed.entry(post, url: post.url) do |entry|
      entry.url(post.url)
      entry.title(post.title)
      entry.content type: 'html' do |c|
        c.cdata!(render_text(post.body))
      end
      entry.author do |author|
        author.name(post.user.name)
        author.uri(blog_root_url)
      end
    end
  end
end
