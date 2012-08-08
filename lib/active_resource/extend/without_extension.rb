module ActiveResource #:nodoc:
  module Extend
    module WithoutExtension
      module ClassMethods
        def element_path_with_extension(*args)
          element_path_without_extension(*args).gsub(/.json|.xml/,'')
        end
        def new_element_path_with_extension(*args)
          new_element_path_without_extension(*args).gsub(/.json|.xml/,'')
        end
        def collection_path_with_extension(*args)
          collection_path_without_extension(*args).gsub(/.json|.xml/,'')
        end
      end

      def self.included(base)
        base.class_eval do
          extend ClassMethods
          class << self
            alias_method_chain :element_path, :extension
            alias_method_chain :new_element_path, :extension
            alias_method_chain :collection_path, :extension
          end
        end
      end
    end
  end
end
