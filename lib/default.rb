# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module SideNavHelper extend self
  def menu_api(items)
  	i = items.select{|x| x.identifier.start_with?("/docs/transfer-api")}
  	self.sort_menuitems(i,':menu_weight')
	end

	def sort_menuitems(items, sort_by)
		items.sort_by { |a| a[sort_by] }
	end

	def menu_toolkit(items)
		i = items.select{|x| x.identifier.start_with?("/docs/toolkit")}
		self.sort_menuitems(i,':menu_weight')
	end
end

# include SideNavHelper