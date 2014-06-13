# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module SideNavHelper
  def transfer_api_navs(item)
    # attribute_to_time(post[:created_at]).strftime('%B %-d, %Y')
  end
end

include SideNavHelper

# def transfer_apis
	# @items.each do |item|
		# puts item.identifier
		# item_root = '/docs/transfer-api'
		# return "#{item.identifier}<hr>"
	# end
		#print item.identifier
		# print '<br>'
		# print item.identifier.start_with?(item_root)
		# print '<br>'
		# print item.identifier.sub! item_root, ''
		# print '<hr>'
	#end
# end