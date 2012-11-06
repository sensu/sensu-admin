class Resting

  def initialize(json)
    json.each do |k, v|
      instance_variable_set("@#{k}", v)
      self.class.send(:attr_reader, k)
    end
  end

  def attributes
    attribs = {}
    self.instance_variables.each do |v|
      attribs.merge!({v.to_s[1..-1] => self.instance_variable_get(v)})
    end
    attribs
  end

  def self.all
    get(collection_name)
  end

  def self.all_raw
    get(collection_name, true)
  end

  def self.find(id)
    get(collection_name + "/#{id}")
  end

  def self.create(path, attributes = {})
    post(singular_name + "/#{path}", attributes)
  end

  #
  # For singular destruction where you want the path based off the class
  #
  def self.destroy(path)
    delete(singular_name + "/#{path}")
  end

  def delete(path)
    self.class.delete(path)
  end

  protected

  class << self
    def collection_name
      self.name.downcase.pluralize
    end

    def singular_name
      self.name.downcase
    end

    def delete(path)
      begin
        RestClient.delete "#{Setting.api_server}/#{path}"
      rescue RestClient::ResourceNotFound
        false
      end
    end

    def put(path, attributes = {})
      begin
        RestClient.put "#{Setting.api_server}/#{path}", attributes.to_json
      rescue RestClient::ResourceNotFound
        false
      end
    end

    def post(path, attributes = {})
      begin
        RestClient.post "#{Setting.api_server}/#{path}", attributes.to_json
      rescue RestClient::ResourceNotFound
        false
      end
    end

    def get(path, raw = false)
      begin
        data = JSON.parse(RestClient.get "#{Setting.api_server}/#{path}")
        if raw
          data
        else
          case data
          when Array
            data.collect{|j| self.new(j)}
          when Hash
            self.new(data)
          end
        end
      rescue RestClient::ResourceNotFound
        false
      end
    end
  end
end
