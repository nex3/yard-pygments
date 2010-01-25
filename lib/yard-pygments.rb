require 'rb-pygments'

YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/../templates'

module YARD
  # @private
  module Templates::Helpers::HtmlSyntaxHighlightHelper
    def method_missing(name, *args, &block)
      type = name.to_s[/^html_syntax_highlight_(.*)/, 1]
      type = type.downcase if type
      return super unless type && Pygments.languages.include?(type)
      source = args.first
      Pygments.highlight(source, type, :html, :nowrap => true, :classprefix => "pyg-")
    end

    def respond_to?(name)
      super || (name =~ /^html_syntax_highlight_(.*)/ &&
        Pygments.languages.include?($1.downcase))
    end
  end
end
