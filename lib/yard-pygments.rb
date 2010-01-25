require 'shellwords'

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

  # A module wrapping the [Pygments](http://pygments.org) command-line interface.
  module Pygments
    extend self

    # Returns a list of all langauges supported by Pygments.
    # This list contains the short names of the languages
    # as documented [on the Pygments site](http://pygments.org/docs/lexers/).
    #
    # @return [Array<String>]
    def languages
      @languages ||= languages!
    end

    # Returns the style definitions for a given style and formatter.
    # For example, returns the CSS definitions for the HTML formatter
    # and the LaTeX style definitions for the LaTeX formatter.
    #
    # @param style [#to_s] The name of the color theme to use, e.g. `:default` or `:colorful`.
    #   The full list of color themes can be found by running `pygmentize -L styles`.
    # @param formatter [#to_s] The name of the formatter to use, e.g. `:html` or `:latex`.
    #   The full list of formatters can be found by running `pygmentize -L formatters`,
    #   or [online](http://pygments.org/docs/formatters/).
    #   At time of writing only `:html` and `:latex` support styles.
    # @param options [{String => String}] Options passed to the formatter.
    #   These are formatter-specific;
    #   available options for a formatter can be found by running
    #   `pygmentize -H formatter #{formatter}`.
    # @return [String]
    def style(style, formatter, options = {})
      execute(["-S", style, "-f", formatter] + convert_options(options))
    end

    # Returns the source code, highlighted using the given lexer and formatter.
    # For example, returns HTML markup surrounding the source code for the `:html` formatter,
    # or LaTeX markup for the `:latex` formatter.
    #
    # @param source [String] The source code to be highlighted
    # @param lexer [#to_s] The name of the lexer (that is, language) to use, e.g. `:ruby` or `:python`.
    #   The full list of lexers can be found by running `pygmentize -L lexers`,
    #   or [online](http://pygments.org/docs/lexers/).
    # @param formatter [#to_s] The name of the formatter to use, e.g. `:html` or `:latex`.
    #   The full list of formatters can be found by running `pygmentize -L formatters`,
    #   or [online](http://pygments.org/docs/formatters/).
    # @param options [{String => String}] Options passed to the formatter and lexer.
    #   These are specific to the formatter and lexer being used;
    #   available options can be found by running `pygmentize -H formatter #{formatter}`
    #   or `pygmentize -H lexer #{lexer}`.
    # @return [String]
    def highlight(source, lexer, formatter, options = {})
      execute(["-l", lexer, "-f", formatter] + convert_options(options), source)
    end

    private

    def convert_options(options)
      options.inject([]) {|a, (n, v)| a + ["-P", "#{n}=#{v}"]}
    end

    def languages!
      execute(%w[-L lexers]).split("\n").grep(/^\* (.*):$/) {$1.split(",").map {|s| s.strip}}.flatten
    end

    def execute(flags, stdin = nil)
      flags = flags.flatten.map {|f| Shellwords.shellescape(f.to_s)}.join(" ")
      IO.popen("pygmentize #{flags}", stdin ? "r+" : "r") do |io|
        if stdin
          io.puts stdin
          io.close_write
        end

        io.read
      end
    end
  end
end
