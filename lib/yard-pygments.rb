require 'shellwords'

module YARD
  module Templates::Helpers::HtmlSyntaxHighlightHelper
    def method_missing(name, *args, &block)
      type = name.to_s[/^html_syntax_highlight_(.*)/, 1]
      type = type.downcase if type
      return super unless type && Pygments.languages.include?(type)
      source = args.first
      Pygments.highlight(source, type, :html, :nowrap => true, :noclasses => true)
    end

    def respond_to?(name)
      super || (name =~ /^html_syntax_highlight_(.*)/ &&
        Pygments.languages.include?($1.downcase))
    end
  end

  module Pygments
    extend self

    def languages
      @languages ||= languages!
    end

    def style(style, formatter, options = {})
      execute(["-S", style, "-f", formatter] + convert_options(options))
    end

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
