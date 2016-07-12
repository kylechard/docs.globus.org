# useful methods for layout processing

module GlobusLayoutHelpers
  def self.get_layout_vars(item)
    case item.identifier.to_s
    when /\/api\/auth\//
      {
        :menu_name => 'Auth API Menu',
        :index_doc => '/api/auth/index.adoc',
        :page_class => 'api-page'
      }
    when /\/api\/transfer\//
      {
        :menu_name => 'Transfer API Menu',
        :index_doc => '/api/transfer/index.adoc',
        :page_class => 'api-page'
      }
    when /\/api\/helper-pages\//
      {
        :menu_name => 'Helper Pages Menu',
        :index_doc => '/api/helper-pages/index.adoc',
        :page_class => 'api-page'
      }
    when /\/cli\//
      {
        :menu_name => 'CLI Menu',
        :index_doc => '/cli/index.adoc',
        :page_class => 'cli-page'
      }
    when /\/site-docs\//
      {
        :menu_name => 'Site Docs Menu',
        :index_doc => '/site-docs/index.adoc',
        :page_class => 'site-docs-page'
      }
    when /\/faq\//
      {
        :menu_name => 'FAQ Categories',
        :index_doc => '/faq/index.adoc',
        :page_class => 'faq-page'
      }
    when /\/release-notes\//
      {
        :menu_name => 'Release Notes Menu',
        :index_doc => '/release-notes/index.adoc',
        :page_class => 'rn-page'
      }
    else
      raise "Uh-oh! Failed to determine layout vars for #{item.identifier.to_s}"
    end
  end

  def self.get_title(item)
    # look for a line that looks like
    #   = TITLE
    (/^= (?<title>.*)$/.match(item.raw_content))[:title] rescue nil
  end
end
