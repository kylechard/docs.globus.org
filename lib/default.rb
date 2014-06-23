# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module SideNavHelper extend self
  def menu_api(items)
  	i = items.select{|x| x.identifier.start_with?("/docs/transfer-api")}
		i.sort_by { |a| a[:menu_weight] }
	end

	def menu_toolkit(items)
		i = items.select{|x| x.identifier.start_with?("/docs/toolkit")}
		i.sort_by { |a| a[:menu_weight] }
	end
end

# include SideNavHelper