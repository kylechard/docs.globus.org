# useful methods and shared transformations for compilation

module GlobusRuleHelpers
  # determine the layout for a given item if it doesn't specify its layout
  # explicitly
  def self.determine_layout(item)
    (item[:layout] ||
     case item.identifier.to_s
     # matches "/api/*/**" -- note that we can't use "/api/**" because that
     # matches on the index doc, which we don't want to include
     #
     # matches "/site-docs/**", "/faq/**", "/cli/**", "/release-notes/**", and "/toolkit/**"
     when /\/((api\/.*)|site-docs|faq|cli|release-notes|toolkit)\//
       '/sidebar_page.*'
     else
       '/default.*'
     end)
  end
end
