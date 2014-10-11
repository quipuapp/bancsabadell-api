module BancSabadell
  class Base
    include BancSabadell::Operations::All

    attr_accessor :created_at, :updated_at

    def initialize(attributes = {})
      set_attributes(attributes)
      parse_timestamps
    end

    def set_attributes(attributes)
      attributes.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def parse_timestamps
      @created_at = Time.at(created_at) if created_at
      @updated_at = Time.at(updated_at) if updated_at
    end

    def self.scope_attribute
    end
  end
end
