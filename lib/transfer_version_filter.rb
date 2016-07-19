class GlobusTransferVersionFilter < Nanoc::Filter
  identifier :globus_transfer_version
  def run(content, params = {})
    content.gsub(/__TRANSFER_VERSION__/, 'v0.10')
  end
end
