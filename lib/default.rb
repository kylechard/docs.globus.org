# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require "nanoc/toolbox"


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

    def cliref_list(items)
  		i = items.select{|x| x.identifier.start_with?("/about/cli-reference/adoc")}
      	self.sort_menuitems(i,':menu_weight')
    end
end


# Overide Nanoc::Toolbox::Helpers::Navigation#breadcrumb_for method
def breadcrumb_for(identifier, options={})
  options[:collection_tag]   ||= 'ol'
  options[:collection_class] ||= 'breadcrumb'

  # Retreive the breadcrumbs trail and format them
  sections = find_breadcrumbs_trail(identifier)
  
  # Customer code
  sections[0][:title] = 'home' # rename the first to home
  sections.pop # remove last

  sections.each_with_index do |bc, index|
    i = @items.find { |x| x.path == bc[:title] }

    if !i.nil?
      sections[index][:title] = i.identifier.split('/').last
    end
  end
  # End Customer code

  render_menu(sections, options)
end


def build_nav
  fn = File.dirname(File.expand_path(__dir__)) + '/menus.yaml'
  menus = YAML::load(File.read(fn))

end



# include SideNavHelper
