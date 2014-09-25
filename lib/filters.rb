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
      
      doc.css('head')[0].remove

      doc.css('div.titlepage')[0].remove
      doc.css('div.titlepage').css('hr').remove

      doc.css('table').add_class('table').remove_attr('width')
      doc.css("table[border='1']").add_class('table-bordered')
      
      doc.css("div.note").remove_attr('style').add_class('alert alert-info')
      doc.css("div.important").remove_attr('style').add_class('alert alert-warning')
      doc.css("div.warning").remove_attr('style').add_class('alert alert-danger')
      doc.css("div.tip").remove_attr('style').add_class('alert alert-info')

      doc.to_html
    end
  end


end