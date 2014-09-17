# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'nanoc' do
  watch('nanoc.yaml') # Change this to config.yaml if you use the old config file name
  watch('Rules')
  watch(%r{^(content|layouts|lib)/.*$})
end

#guard 'livereload' do
#  watch(%r{content/.+\.(html|yaml|adoc|erb|css)$})
#  watch(%r{layouts/.+\.(html|erb)$})
#  watch('Rules')

  #watch(%r{app/views/.+\.(erb|haml|slim)$})
  #watch(%r{app/helpers/.+\.rb})
  #watch(%r{public/.+\.(css|js|html)})
  #watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  #watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
#end
