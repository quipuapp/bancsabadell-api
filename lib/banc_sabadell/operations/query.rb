
module BancSabadell
  module Operations
    module Query
      module ClassMethods
        def query(options = {})
          keyword_options = options.delete(scope_attribute)
          more_pages_container = options.delete(:more_pages_container)

          req = BancSabadell.request(:post, generate_url_keyword(keyword_options), options)
          res = req.perform
          more_pages_container.has_more_pages = req.more_pages? if more_pages_container

          results_from res
        end

        def next_page(options = {})
          query(options.merge(page: 'next')) if has_more_pages
        end

        private

        def results_from(res)
          (res['data'] || []).map do |row|
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
