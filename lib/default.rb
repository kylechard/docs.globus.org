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


# Ref Nanoc::Toolbox::Helpers::Navigation#breadcrumb_for method
def globus_breadcrumb_for(identifier, options={})
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


# Ref Nanoc::Toolbox::Helpers::Navigation#render_menu method
def globus_render_menu(items, options={})
  options[:depth]            ||= 3
  options[:collection_tag]   ||= 'ol'
  options[:collection_class] ||= 'menu'
  options[:item_tag]         ||= 'li'
  options[:title_tag]        ||= 'h2'
  options[:title]            ||= nil
  options[:separator]        ||= ''
  


  # Parse the title and remove it from the options
  title =  options[:title] ? content_tag(options[:title_tag], options[:title]) : ''
  options.delete(:title_tag)
  options.delete(:title)

  # Decrease the depth level
  options[:depth] -= 1


  rendered_menu = items.map do |item|
    # Reset item and link options
    options[:link_attr] = {}
    options[:item_class] = nil

    # Set item active class
    options[:item_class] = ( @item.identifier == item[:link] || @item.identifier.start_with?(item[:link]) ) ? 'active' : '' 

    # Render only if there is depth left
    if options[:depth].to_i  > 0 && item[:subsections]


      # Save previously set collection_class for later
      collection_class = options[:collection_class]
      options[:collection_class] = 'dropdown-menu'

      output = globus_render_menu(item[:subsections], options)

      options[:depth] += 1 # Increase the depth level after the call of navigation_for

      options[:collection_class] = collection_class #reset value to preivous value
      # Toggle item and link dropdowns
      options[:item_class] = 'dropdown'

      options[:link_attr] = {:class => 'dropdown-toggle', 'data-toggle' => 'dropdown'}
    end
    output ||= ""
    # content_tag(options[:item_tag], link_to_unless_current(item[:title], item[:link]) + options[:separator] + output)
    content_tag(options[:item_tag], link_to(item[:title], item[:link], options[:link_attr]) + options[:separator] + output, :class => options[:item_class])

  end.join()

  # title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?
  title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?


end

# Build menus yaml file
def globus_build_menu(menu_name)
  fn = File.dirname(File.expand_path(__dir__)) + '/menus.yaml'
  yaml = YAML.load(File.read(fn)).select { |key, value| key.to_s == menu_name }.values[0]
  menu = symbolize_keys(yaml)
  options = menu[:options]
  items =  menu[:items]
  globus_render_menu(items, options)
end


# Recursively convert arrays keys to symbolized hash
def symbolize_keys(x)
  if x.is_a? Hash
    x.inject({}) do |result, (key, value)|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  when Array then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
      result
    end
  elsif x.is_a? Array
    x.map {|el| symbolize_keys(el)}
  else
    x
  end
end

# include SideNavHelper
