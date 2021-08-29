# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Search
        #
        # Searches all pages and child pages that are shared with the integration.
        # The results may include databases.
        #
        # @option options [string] :query
        #   When supplied, limits which pages are returned by comparing the query to the page title.
        #
        # @option options [Object] :filter
        #   When supplied, filters the results based on the provided criteria.
        #
        # @option options [[Object]] :sorts
        #   When supplied, sorts the results based on the provided criteria.
        #   Limitation: Currently only a single sort is allowed and is limited to last_edited_time.
        #
        # @option options [UUID] :start_cursor
        #   Paginate through collections of data by setting the cursor parameter
        #   to a start_cursor attribute returned by a previous request's next_cursor.
        #   Default value fetches the first "page" of the collection.
        #   See pagination for more detail.
        #
        # @option options [integer] :page_size
        #   The number of items from the full list desired in the response. Maximum: 100
        def search(options = {})
          if block_given?
            Pagination::Cursor.new(self, :search, options).each do |page|
              yield page
            end
          else
            post('search', options)
          end
        end
      end
    end
  end
end
