class GlobusAsciiDocFilter < Nanoc::Filter
  identifier :globus_asciidoc

  # Runs the content through [AsciiDoc](http://www.methods.co.nz/asciidoc/).
  def run(content, params = {})
    # capture stdout from the command as a string
    stdout = StringIO.new
    # run the asciidoc command with our custom backend -- reading the content
    # from stdin and printing to the capturing StringIO
    piper = Nanoc::Extra::Piper.new(:stdout => stdout, :stderr => $stderr)
    piper.run(%w(asciidoc -b bootstrap -o - -), content)

    # return the resulting output
    stdout.string
  end
end
