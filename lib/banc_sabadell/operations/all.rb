module BancSabadell
  module Operations
    module All
      module ClassMethods
        def all(options = {})
          keyword_options = options.delete(scope_attribute)

          req = BancSabadell.request(:post, generate_url_keyword(keyword_options), options)
          res = req.perform

          while req.more_pages?
            new_req = BancSabadell.request(:post, generate_url_keyword(keyword_options), options.merge(page: 'next'))
            new_res = new_req.perform
            res['data'].concat(new_res['data'])
            res['head'] = new_res['head']
          end

          results_from res
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
