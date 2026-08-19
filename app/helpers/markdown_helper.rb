module MarkdownHelper
  def markdown(text)
    return '' if text.blank?

    Commonmarker.to_html(text, options: { parse: { smart: true } }).html_safe # rubocop:disable Rails/OutputSafety
  end
end
