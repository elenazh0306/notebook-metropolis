module ApplicationHelper
  def render_markdown(text)
    return "" if text.blank?

    # Initialize Redcarpet renderer
    renderer = Redcarpet::Render::HTML.new(
      filter_html: false,
      hard_wrap: true
    )

    markdown = Redcarpet::Markdown.new(
      renderer,
      fenced_code_blocks: true,
      autolink: true,
      tables: true
    )

    # Convert Markdown string into HTML
    markdown.render(text)
  end
end
