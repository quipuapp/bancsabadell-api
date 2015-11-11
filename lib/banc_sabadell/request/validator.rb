module BancSabadell
  module Request
    class Validator
      def validate_response(response)
        code = response.code.to_i

        raise AuthenticationError.new('Unauthorized') if code == 401
        raise APIError.new('Server Error') if code >= 500
      end

      def validate_response_data(response_data)
        rd = response_data

        if rd
          if rd["data"] &&
             rd["data"].is_a?(Hash) &&
             rd["data"]["error"]
               raise APIError.new(rd["data"]["error"])
          elsif rd["head"] &&
                rd["head"]["errorCode"]
            raise APIError.new(rd["head"]["descripcionError"]) unless is_bogus_error(rd)
          end
        end
      end

      private

      def is_bogus_error(response_data)
        # How is a lack of data an error? You're killing me here guys...
        response_data["head"]["descripcionError"].include?("Z11421")
      end
    end
  end
end
