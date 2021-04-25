# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Databases
        #
        # Retrieves a Database object using the ID specified in the request.
        #
        # Returns a 404 HTTP response if the database doesn't exist, or if the bot
        # doesn't have access to the database. Returns a 429 HTTP response if the
        # request exceeds Notion's Request limits.
        #
        # @option options [id] :id
        #   Database to get info on.
        def database(options = {})
          throw ArgumentError.new('Required arguments :id missing') if options[:id].nil?
          get("databases/#{options[:id]}")
        end

        #
        # Gets a paginated array of Page object s contained in the requested database,
        # filtered and ordered according to the filter and sort objects provided in the request.
        #
        # Filters are similar to the filters provided in the Notion UI. Filters operate
        # on database properties and can be combined. If no filter is provided, all the
        # pages in the database will be returned with pagination.
        #
        # Sorts are similar to the sorts provided in the Notion UI. Sorts operate on
        # database properties and can be combined. The order of the sorts in the request
        # matter, with earlier sorts taking precedence over later ones.
        #
        # @option options [id] :id
        #   Database to query.
        #
        # @option options [Object] :filter
        #   When supplied, limits which pages are returned based on the provided criteria.
        #
        # @option options [[Object]] :sorts
        #   When supplied, sorts the results based on the provided criteria.
        #
        # @option options [UUID] :start_cursor
        #   Paginate through collections of data by setting the cursor parameter
        #   to a start_cursor attribute returned by a previous request's next_cursor.
        #   Default value fetches the first "page" of the collection.
        #   See pagination for more detail.
        def database_query(options = {})
          throw ArgumentError.new('Required arguments :id missing') if options[:id].nil?
          if block_given?
            Pagination::Cursor.new(self, :database_query, options).each do |page|
              yield page
            end
          else
            post("databases/#{options[:id]}/query", options)
          end
        end
      end
    end
  end
end