# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require "nanoc/toolbox"

module SideNavHelper extend self
    def sort_menuitems(items, sort_by)
        items.sort_by { |a| a[sort_by] }
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
  options[:collection_tag]   ||= 'ul'
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
    options[:link_attr] = {
      :class => item[:class] ? item[:class] : ''
    }
    options[:item_class] = nil

    # Set item active class
    if item[:link]
      options[:item_class] = ( @item.identifier == item[:link] || @item.identifier.start_with?(item[:link]) ) ? 'active' : ''

      # Set link active if hide_item_tag is true (toolkit)
      if options[:hide_item_tag] && ( @item.identifier == item[:link] || @item.identifier.start_with?(item[:link]))
        options[:link_attr][:class] = options[:link_attr][:class] + ' active'
      end
    end

    # Render only if there is depth left
    if options[:depth].to_i  > 0 && item[:subsections]


      # Save previously set collection_class for later
      collection_class = options[:collection_class]
      options[:collection_class] = 'dropdown-menu'

      output = globus_render_menu(item[:subsections], options)

      # Add caret to drop-downs in main menu
      item[:title] += ' '
      item[:title] += content_tag('span', '', :class => 'caret')

      options[:depth] += 1 # Increase the depth level after the call of navigation_for

      options[:collection_class] = collection_class #reset value to previous value
      # Toggle item and link dropdowns
      options[:item_class] = 'dropdown'

      options[:link_attr][:class] =  options[:link_attr][:class] + ' dropdown-toggle'
      options[:link_attr]['data-toggle'] = 'dropdown'
    end
    output ||= ""
    # content_tag(options[:item_tag], link_to_unless_current(item[:title], item[:link]) + options[:separator] + output)
    case item[:type]
    when 'divider'
      link = content_tag('div', item[:title], options[:link_attr])
    else
      link = link_to(item[:title], item[:link], options[:link_attr])
    end

    if options[:hide_item_tag]
      link + options[:separator] + output
    else
      content_tag(options[:item_tag], link + options[:separator] + output, :class => options[:item_class])
    end
  end.join()

  # title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?
  title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?


end

# ------------------------
# Sidebar Menus
#------------------------

# File 'lib/nanoc/toolbox/helpers/navigation.rb', line 26

def globus_navigation_for(identifier, options={})

  # Get root item for which we need to draw the navigation
  root = @items.find { |i| i.identifier == identifier }

  # Do not render if there is no child
  return nil unless root.children

  # Find all sections, and render them
  sections = globus_find_item_tree(root)

  # add root item to top of list. pretty sure there's a better way to do this but couldn't find it.
  theroot={}
  theroot[:title] = root[:short_title] || root[:title] || root.identifier
  theroot[:link] = root.identifier || relative_path_to(root)
  theroot[:menu_weight]  = root[:menu_weight] || 0
  theroot[:subsections] = ""

  sections.unshift(theroot)

  globus_render_sidebar_menu(sections, options)
end

# Recursive method that extract from an XPath pattern the document structure
# and return the "permalinks" in a Array of Hash that could be used by the
# rendering method
def globus_find_item_tree(root)
    return nil unless root.children

    # For each child call the find_item_tree on it and then render the generate the hash
    sections = root.children.map do |child|
      subsections = globus_find_item_tree(child)
      { :title        => (child[:short_title] || child[:title] || child.identifier),
        :link         => (child.identifier || relative_path_to(child)),
        :menu_weight  => (child[:menu_weight] || 0),
        :subsections  => subsections }
    end

    sections
end


# Ref Nanoc::Toolbox::Helpers::Navigation#render_menu method
def globus_render_sidebar_menu(items, options={})
  options[:collection_tag]    ||= 'div'
  options[:collection_class]  ||= 'panel panel-default'
  options[:depth]             ||= 2
  options[:item_tag]         ||= 'div'
  options[:title_tag]        ||= 'h2'
  options[:title]            ||= nil
  options[:separator]        ||= ''
  options[:header_tag]       ||= 'div'
  options[:header_class]     ||= 'panel-heading'
  options[:mobile]           ||= ''
  options[:caret_class]      ||= 'caret'
  options[:menu_weight]      ||= 0

  # Parse the title and remove it from the options
  title =  options[:title] ? content_tag(options[:title_tag], options[:title]) : ''
  options.delete(:title_tag)
  options.delete(:title)

  # Decrease the depth level
  options[:depth] -= 1

  # Sort items by menu_weight
  items.sort!{|a,b| a[:menu_weight]<=>b[:menu_weight]}

  rendered_menu = items.map do |item|
    # Reset item and link options
    item_class = item[:class] ? item[:class] : ''
    menu_weight = item[:menu_weight] ? item[:menu_weight].to_i : 0
    options[:item_class] = nil

    # Set item active class
    if item[:link]
        if @item.identifier == item[:link]
            item_class += ' active'
        end
    end

    # Render only if there is depth left
    # Had to use .length because of /foo/ to /foo/index.html routing
    if options[:depth].to_i  > 0 && item[:subsections].length > 0

      # Save previously set collection_class & caret for later
      collection_class = options[:collection_class]
      caret_class = options[:caret_class]

      options[:collection_class] = 'panel-collapse collapse'

      if @item.identifier == item[:link] || @item.identifier.start_with?(item[:link])
        options[:collection_class] += ' in'
        options[:caret_class] += ' open'
      end

      output = content_tag(options[:header_tag], globus_render_sidebar_menu(item[:subsections], options), :class => 'list-group')

      # Add caret to drop-downs in main menu
      caret = ''
        caret = content_tag('a', content_tag('span','', :class => 'caret'), :class => options[:caret_class])

      options[:depth] += 1 # Increase the depth level after the call of navigation_for

      #reset value to previous values
      options[:collection_class] = collection_class
      options[:caret_class] = caret_class

      options[:link_attr] = { :class => item_class }

        output ||=""
        link = link_to(item[:title], item[:link], options[:link_attr])
        content_tag(options[:header_tag], link + options[:separator] + caret, :class => options[:header_class]) + output

    else
    output ||= ""

    # Update item's classes
    item_class += ' list-group-item'

    options[:link_attr] = { :class => item_class }

    link_to(item[:title], item[:link], options[:link_attr]) + output

    end
  end.join()
  title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?
end

# Load menu from menus.yaml file
def globus_load_menu(file_name)
  # fn = File.dirname(File.expand_path(__dir__)) + '/menus.yaml'
  # fn = File.dirname(File.expand_path(__dir__))
  # yaml = YAML.load(File.read(fn)).select { |key, value| key.to_s == menu_name }.values[0]
  #
  file = 'static/menus/' + file_name + '.yaml'
  yaml = YAML.load(File.read(file))
  if !yaml
    abort 'Menu file cannot be empty in ' + file
  elsif !yaml.has_key?("menus")
    abort 'Cannot find "menus" key in ' + file
  end

  # puts '+++++++++++++++'
  # puts yaml[:menus]
  # abort '-----------'

  # yaml['options'] ||= {}
  # yaml['items'] ||= {}

  symbolize_keys(yaml)[:menus]
end


# Build menus yaml file
def globus_build_menu(menu_name)
  menus = globus_load_menu(menu_name)

  if menus.size == 1
    globus_render_menu(menus[0][:items], menus[0][:options])
  elsif menus.size > 1
    menus.map do |menu|
      globus_render_menu(menu[:items], menu[:options])
    end
  end

  # menus.map do |menu|
  #   options = menu[:options]
  #   items =  menu[:items]
  #   rendered_menus.push(globus_render_menu(items, options))
  # end

  # puts '+++++++'
  # puts
  # puts '-----------'

  # abort

  # abort
  # globus_render_menu(items, options)
end


# Recursively convert arrays keys to symbolized hash
# Source: https://gist.github.com/neektza/8585746
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
