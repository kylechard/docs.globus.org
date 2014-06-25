# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module SideNavHelper extend self
  def menu_api(items)
  	i = items.select{|x| x.identifier.start_with?("/transfer-api/docs")}
  	self.sort_menuitems(i,':menu_weight')
	end

	def sort_menuitems(items, sort_by)
		items.sort_by { |a| a[sort_by] }
	end

	def menu_toolkit(items)
		i = items.select{|x| x.identifier.start_with?("/toolkit/docs")}
		self.sort_menuitems(i,':menu_weight')
	end
end

# include SideNavHelper