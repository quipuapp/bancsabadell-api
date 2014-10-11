module BancSabadell
  module Operations
    module All
      module ClassMethods
        def all(options = {})
          results_from BancSabadell.request(:get, url_keyword, options)
        end

        private

        def results_from(response)
          response['data'].map do |row|
            treated_row = row.map do |key, value|
              { self.attribute_translations[key.to_sym].to_s => value }
            end.inject(:merge)

            self.new(treated_row)
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
