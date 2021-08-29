# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Databases
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
        # @option options [id] :database_id
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
        #
        # @option options [integer] :page_size
        #   The number of items from the full list desired in the response. Maximum: 100
        def database_query(options = {})
          throw ArgumentError.new('Required arguments :database_id missing') if options[:database_id].nil?
          if block_given?
            Pagination::Cursor.new(self, :database_query, options).each do |page|
              yield page
            end
          else
            post("databases/#{options[:database_id]}/query", options)
          end
        end

        #
        # Creates a new database in the specified page.
        #
        # @option options [Object] :parent
        #   Parent of the database, which is always going to be a page.
        #
        # @option options [Object] :title
        #   Title of this database.
        #
        # @option options [Object] :properties
        #   Property schema of database.
        #   The keys are the names of properties as they appear in Notion and the values are
        #   property schema objects. Property Schema Object is a metadata that controls
        #   how a database property behaves, e.g. {"checkbox": {}}.
        #   Each database must have exactly one database property schema object of type "title".
        def create_database(options = {})
          throw ArgumentError.new('Required arguments :parent.page_id missing') if options.dig(:parent, :page_id).nil?
          throw ArgumentError.new('Required arguments :title missing') if options.dig(:title).nil?
          throw ArgumentError.new('Required arguments :properties missing') if options.dig(:properties).nil?
          post('databases', options)
        end

        #
        # Updates an existing database as specified by the parameters.
        #
        # @option options [id] :database_id
        #   Database to update.
        #
        # @option options [Object] :title
        #   Title of database as it appears in Notion. An array of rich text objects.
        #   If omitted, the database title will remain unchanged.
        #
        # @option options [Object] :properties
        #   Updates to the property schema of a database.
        #   If updating an existing property, the keys are the names or IDs
        #   of the properties as they appear in Notion and the values
        #   are property schema objects. If adding a new property, the key is
        #   the name of the database property and the value is a property schema object.
        #
        def update_database(options = {})
          throw ArgumentError.new('Required arguments :database_id missing') if options.dig(:database_id).nil?
          patch("databases/#{options[:database_id]}", options)
        end

        #
        # Retrieves a Database object using the ID specified in the request.
        #
        # Returns a 404 HTTP response if the database doesn't exist, or if the bot
        # doesn't have access to the database. Returns a 429 HTTP response if the
        # request exceeds Notion's Request limits.
        #
        # @option options [id] :database_id
        #   Database to get info on.
        def database(options = {})
          throw ArgumentError.new('Required arguments :database_id missing') if options[:database_id].nil?
          get("databases/#{options[:database_id]}")
        end

        #
        # Returns a paginated list of Databases objects for the workspace.
        #
        # @option options [UUID] :start_cursor
        # Paginate through collections of data by setting the cursor parameter
        # to a start_cursor attribute returned by a previous request's next_cursor.
        # Default value fetches the first "page" of the collection.
        # See pagination for more detail.
        #
        # @option options [integer] :page_size
        #   The number of items from the full list desired in the response. Maximum: 100
        def databases_list(options = {})
          if block_given?
            Pagination::Cursor.new(self, :databases_list, options).each do |page|
              yield page
            end
          else
            get('databases', options)
          end
        end
      end
    end
  end
end