module BancSabadell
  module Request
    class Base
      attr_reader :info
      attr_accessor :response
      attr_accessor :parsed_data

      def initialize(info)
        @info = info
      end

      def perform
        connection.setup_https

        self.response = connection.request
        validator.validate_response(response)

        self.parsed_data = JSON.parse(response.body)
        validator.validate_response_data(parsed_data)

        self.parsed_data
      end

      def more_pages?
        parsed_data['head'] &&
        parsed_data['head']['warnCode'] &&
        parsed_data['head']['warnCode'] == "WARN-MOV-001"
      end

      protected

      def connection
        @connection ||= Connection.new(info)
      end

      def validator
        @validator ||= Validator.new
      end

    end
  end
end
