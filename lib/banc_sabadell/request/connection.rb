module BancSabadell
  module Request
    class Connection
      include Helpers
      attr_reader :https

      def initialize(request_info)
        @info = request_info
      end

      def setup_https
        @https = Net::HTTP.new(BancSabadell.api_base, BancSabadell.api_port)
        @https.use_ssl = true
        @https.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO remove it
      end

      def request
        response = https.request(https_request)
        log_request_info(response)
        response
      end

      private

      def https_request
        https_request = case @info.http_method
                        when :post
                          Net::HTTP::Post.new(@info.url)
                        when :put
                          Net::HTTP::Put.new(@info.url)
                        when :delete
                          Net::HTTP::Delete.new(@info.url)
                        else
                          Net::HTTP::Get.new(@info.path_with_params(@info.url, @info.data))
                        end

        if [:post, :put].include?(@info.http_method)
          https_request.set_form_data(normalize_params(@info.data))
        end

        https_request
      end

      def log_request_info(response)
        if @info
          BancSabadell.logger.info "[BancSabadell] [#{current_time}] #{@info.http_method.upcase} #{@info.url} #{response.code}"
        end
      end

      def current_time
        Time.now.utc.strftime("%d/%b/%Y %H:%M:%S %Z")
      end
    end
  end
end

