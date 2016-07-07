# useful methods and shared transformations for compilation

module GlobusRuleHelpers
  # determine the layout for a given item if it doesn't specify its layout
  # explicitly
  def self.determine_layout(item)
    (item[:layout] ||
     case item.identifier.to_s
     when /\/api\/transfer\//
       '/tapi.*'
     when /\/api\/auth\//
       '/aapi.*'
     when /\/cli\//
       '/cli.*'
     when /\/faq\//
       '/faq.*'
     when /\/release-notes\//
       '/release-notes.*'
     when /\/site-docs\//
       '/site-docs.*'
     else
       '/default.*'
     end)
  end
end
