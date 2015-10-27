module BancSabadell
  module Operations
    module All
      module ClassMethods
        def all(options = {})
          keyword_options = options.delete(scope_attribute)

          response = BancSabadell.request(:post, generate_url_keyword(keyword_options), options)

          while more_pages?(response)
            new_response = BancSabadell.request(:post, generate_url_keyword(keyword_options), options.merge(page: 'next'))
            response['data'].concat(new_response['data'])
            response['head'] = new_response['head']
          end

          results_from response
        end

        private

        def results_from(response)
          (response['data'] || []).map do |row|
            treated_row = row.map do |key, value|
              { attribute_translations[key.to_sym].to_s => value }
            end.inject(:merge)

            new(treated_row)
          end
        end

        # amazing
        def more_pages?(response)
          response['head'] &&
          response['head']['warnCode'] &&
          response['head']['warnCode'] == "WARN-MOV-001"
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
