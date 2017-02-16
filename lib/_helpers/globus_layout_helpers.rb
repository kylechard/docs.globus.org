# useful methods for layout processing

module Nanoc::Helpers
  module GlobusLayoutHelpers
    def globus_get_layout_vars(item)
      case item.identifier.to_s
      when /\/api\/auth\//
        {
          :menu_name => 'Auth API Menu',
          :index_loc => '/api/auth/',
          :page_class => 'api-page'
        }
      when /\/api\/transfer\//
        {
          :menu_name => 'Transfer API Menu',
          :index_loc => '/api/transfer/',
          :page_class => 'api-page'
        }
      when /\/api\/helper-pages\//
        {
          :menu_name => 'Helper Pages Menu',
          :index_loc => '/api/helper-pages/index.adoc',
          :page_class => 'api-page'
        }
      when /\/cli\//
        {
          :menu_name => 'CLI Menu',
          :index_loc => '/cli/',
          :page_class => 'cli-page'
        }
      when /\/premium-storage-connectors\//
        {
          :menu_name => 'Premium Storage Connectors Menu',
          :index_loc => '/premium-storage-connectors/',
          :page_class => 'stc-page'
        }
      when /\/site-docs\//
        {
          :menu_name => 'Site Docs Menu',
          :index_loc => '/site-docs/',
          :page_class => 'site-docs-page'
        }
      when /\/faq\//
        {
          :menu_name => 'FAQ Categories',
          :index_loc => '/faq/',
          :page_class => 'faq-page'
        }
      when /\/release-notes\//
        {
          :menu_name => 'Release Notes Menu',
          :index_loc => '/release-notes/',
          :page_class => 'rn-page'
        }
      when /\/toolkit\//
        {
          :menu_name => 'Toolkit Menu',
          :index_loc => '/toolkit/',
          :page_class => 'toolkit-page'
        }
      else
        raise "Uh-oh! Failed to determine layout vars for #{item.identifier.to_s}"
      end
    end

    def globus_get_title(item)
      # look for a line that looks like
      #   = TITLE
      item[:title] || (/^= (?<title>.*)$/.match(item.raw_content))[:title] rescue nil
    end
  end
end
