module Nanoc::Helpers
  module GlobusNavigation
    include Nanoc::Helpers::GlobusLayoutHelpers
    include Nanoc::Helpers::Breadcrumbs
    include HtmlTag

    # -----------------------
    # Breadcrumb
    #------------------------
    def globus_breadcrumb_for(item)
      # Retreive the breadcrumbs trail
      trail = breadcrumb_trail(item)
      # render the trail as a menu
      globus_render_menu(trail, {:collection_tag => 'ol', :collection_class => 'breadcrumb'})
    end

    # -----------------------
    # Menus
    #------------------------
    def globus_navigation_for(namespace, options={})
      # Get root item for which we need to draw the navigation
      # this should be the index doc
      root = @items[File.join(namespace, 'index.*')]

      # get all descendants in the given namespace
      # everything in that namespace but the root
      descendants = @items.find_all(File.join(namespace, '**/*.{adoc,html}')).select{|x| x != root}

      # if there are no descendants, no menu
      return if descendants.empty?

      # Find all sections, and render them
      sections = globus_find_item_tree(namespace)

      # add root item to top of list. pretty sure there's a better way to do this but couldn't find it.
      theroot={}
      theroot[:title] = safe_item_title(root)
      theroot[:link] = relative_path_to(root)
      theroot[:menu_weight]  = root[:menu_weight] || 0
      theroot[:subsections] = nil

      sections.unshift(theroot)

      globus_render_sidebar_menu(sections, options)
    end

    # Recursive method that extract from an XPath pattern the document structure
    # and return the "permalinks" in a Array of Hash that could be used by the
    # rendering method
    def globus_find_item_tree(namespace)
      root = @items[File.join(namespace, 'index.*')]
      children = ( @items.find_all(File.join(namespace, '*.{adoc,html}')) +
                   @items.find_all(File.join(namespace, '*/index.*')) ).select{|x| x != root}

      # For each child call the find_item_tree on it and then render the generate the hash
      sections = children.map do |child|
        child_namespace = File.dirname(child.path)
        subsections = if child_namespace != namespace.chomp('/') then globus_find_item_tree(child_namespace) else nil end
        { :title        => safe_item_title(child),
          :link         => relative_path_to(child),
          :menu_weight  => (child[:menu_weight] || 0),
          :subsections  => subsections }
      end

      sections
    end

    # Build menus yaml file
    def globus_build_menu(menu_name)
      menus = load_menu(menu_name)

      if menus.size == 1
        globus_render_menu(menus[0][:items], menus[0][:options] || {})
      elsif menus.size > 1
        menus.map do |menu|
          globus_render_menu(menu[:items], menu[:options] || {})
        end
      end
    end


    private

      # Load menu from menus.yaml file
      def load_menu(file_name)
        # have to symbolize keys in order to have consistent access between
        # loaded yaml and use of symbols in the nav methods
        symbolize_keys(
          YAML.load(
            File.read(
              "content/static/menus/#{file_name}.yaml"
            )
          )["menus"]
        )
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

      def breadcrumb_trail(item)
        # get the raw paths that prefix this item's identifier
        raw_trail = ['/']
        item.identifier.components.each do |comp|
          raw_trail << File.join(raw_trail.last, comp)
        end

        # get items that are either those names followed by "/index.*" (the
        # normal case), or just the name with a trailing ".*"
        item_trail = raw_trail.map do |path|
          (@items[File.join(path, 'index.*')] or @items[path + '.*']) rescue nil
        end.compact

        # reduce those items down to simple Hash descriptions
        item_trail.map! do |x|
          {
            :title => safe_item_title(x),
            :link =>  relative_path_to(x.path),
            :subsections => nil
          }
        end

        # rename the first to Home
        item_trail[0][:title] = 'Home'

        return item_trail
      end

      def safe_item_title(x)
        globus_get_title(x) || x.identifier.components.last
      end

      def globus_render_sidebar_menu(item_descriptors, options={})
        globus_render_menu(item_descriptors, options, true)
      end

      def globus_render_menu(item_descriptors, options={}, sidebar=false)
        options[:depth]            ||= if sidebar then 2 else 3 end
        options[:collection_tag]   ||= if sidebar then 'div' else 'ul' end
        options[:collection_class] ||= if sidebar then 'panel panel-default' else 'menu' end
        options[:item_tag]         ||= if sidebar then 'div' else 'li' end
        options[:title_tag]        ||= 'h2'
        options[:title]            ||= nil
        options[:caret_class]      ||= 'caret'
        options[:header_tag]       ||= 'div'
        options[:header_class]     ||= 'panel-heading'
        options[:menu_weight]      ||= 0

        # Parse the title and remove it from the options
        title = options[:title] ? content_tag(options[:title_tag], options[:title]) : ''
        options.delete(:title_tag)
        options.delete(:title)

        # Decrease the depth level
        options[:depth] -= 1

        if sidebar
          # Sort items by menu_weight
          item_descriptors.sort!{|a,b| a[:menu_weight]<=>b[:menu_weight]}
        end

        # render each item in the menu
        rendered_menu = item_descriptors.map do |item_desc|
          is_current_item = @item.identifier.to_s.start_with?(item_desc[:link]) rescue false

          # Reset item and link options
          # Set item active class
          item_class = is_current_item ? 'active' : ''
          link_attr = { :class => item_class }

          # do we have subsections to render or not?
          # Render only if there is depth left
          subsections = options[:depth].to_i > 0 && item_desc[:subsections]
          if subsections
            # clone the options to make the set of options for a recursive call
            sub_opts = options.clone
            sub_opts[:collection_class] = if sidebar then 'panel-collapse collapse' else 'dropdown-menu' end

            # if looking at the current item
            if sidebar and is_current_item
              sub_opts[:collection_class] += ' in'
              sub_opts[:caret_class] += ' open'
            end

            # call render_menu() recursively on subsections
            output = globus_render_menu(item_desc[:subsections], sub_opts, sidebar)
            if sidebar
              output = content_tag(options[:header_tag], output, :class => 'list-group')
            end

            # Add caret to dropdowns
            item_desc[:title] += ' '
            item_desc[:title] += content_tag('span', '', :class => sub_opts[:caret_class])

            # Toggle item and link dropdowns
            item_class = 'dropdown'

            link_attr[:class] += ' dropdown-toggle'
            link_attr['data-toggle'] = 'dropdown'
          else
            output = ""
            if sidebar
              link_attr[:class] += ' list-group-item'
            end
          end

          # get the link to the item in question
          link = link_to(item_desc[:title], item_desc[:link], link_attr)

          if sidebar
            if subsections
              caret = content_tag('a', content_tag('span','', :class => 'caret'), :class => options[:caret_class])
              content_tag(options[:header_tag], link + caret, :class => options[:header_class]) + output
            else
              link
            end
          else
            content_tag(options[:item_tag], link + output, :class => item_class)
          end
        end.join

        title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?
      end


  end
end
