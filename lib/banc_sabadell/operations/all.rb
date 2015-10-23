module BancSabadell
  module Operations
    module All
      module ClassMethods
        def all(options = {})
          keyword_options = options.delete(scope_attribute)
          results_from BancSabadell.request(:post, generate_url_keyword(keyword_options), options)
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
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
