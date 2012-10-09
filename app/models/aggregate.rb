class Aggregate < ActiveResource::Base
  include ActiveResource::Extend::WithoutExtension
  ActiveResource::Base.include_root_in_json = false
  self.site = APP_CONFIG['api']
  self.format = SensuJSONFormatter.new

  def element_path(id, prefix_options = {}, query_options = nil)
    prefix_options, query_options = split_options(prefix_options) if query_options.nil?
    # path to the resource, which we want to access is evaluated in this statement: 
    "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
  end
end
