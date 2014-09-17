# encoding: utf-8

require 'nokogiri'


module Nanoc::Filters

  # @since 3.2.0
  class AsciiDoc < Nanoc::Filter

    # Runs the content through [AsciiDoc](http://www.methods.co.nz/asciidoc/).
    # This method takes no options.
    #
    # @param [String] content The content to filter
    #
    # @return [String] The filtered content
    def run(content, params = {})
      stdout = StringIO.new
      stderr = $stderr
      piper = Nanoc::Extra::Piper.new(:stdout => stdout, :stderr => stderr)
      piper.run(%w( asciidoc -b bootstrap -o - - ), content)
      # piper.run(%w( asciidoc -b html5 -o - - ), content)
      stdout.string
    end
  end

  # Parse toolkit docs
  class HTMLCompressFilter < Nanoc::Filter
    identifier :parse_toolkit
    type :text

    def run(content, params={})
      doc = Nokogiri::HTML(content)
      
      doc.css('head').remove
      doc.css('div.titlepage').remove

      doc.css('table').add_class('table')
      # puts links.inspect

      # doc.search('//div.titlepage').each do |node|
      #   # node.remove
      #   puts node
      #   # puts node
      #   # node.children.remove
      #   # node.content = 'Children removed.'
      # end

      # Find comments.
      # doc.xpath("//comment()").each do |comment|
      #     # Check it's not a conditional comment.
      #     if (comment.content !~ /\A(\[if|\<\!\[endif)/)
      #         comment.remove()
      #     end
      # end

      doc.to_html
    end
  end


end