module BancSabadell
  module Request
    class Validator
      def validate_response(response)
        code = response.code.to_i

        raise AuthenticationError.new('Unauthorized') if code == 401
        raise APIError.new('Server Error') if code >= 500
        raise APIError.new("Wrong content_type: #{response.content_type}", response.body) if response.content_type != 'application/json'
      end

      def validate_response_data(response_data, unparsed_data = nil)
        rd = response_data

        if rd
          if rd["data"] &&
             rd["data"].is_a?(Hash) &&
             rd["data"]["error"]
               raise APIError.new(rd["data"]["error"], unparsed_data)
          elsif rd["head"] &&
                rd["head"]["errorCode"]
            raise SessionTimeoutError.new(rd["head"]["descripcionError"], unparsed_data) if session_timed_out?(rd)
            raise APIError.new(rd["head"]["descripcionError"], unparsed_data) unless is_bogus_error(rd)
          end
        else
          raise APIError.new('Empty JSON response!', unparsed_data)
        end
      end

      private

      def is_bogus_error(response_data)
        # How is a lack of data an error? You're killing me here guys...
        response_data["head"]["descripcionError"].include?("Z11421")
      end

      def session_timed_out?(response_data)
        response_data["head"]["descripcionError"].include?("F0019")
      end
    end
  end
end
