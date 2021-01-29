# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Users
        #
        # Retrieves a User object using the ID specified in the request.
        #
        # @option options [id] :id
        #   User to get info on.
        def user(options = {})
          throw ArgumentError.new('Required arguments :id missing') if options[:id].nil?
          get("users/#{options[:id]}")
        end

        #
        # Returns a paginated list of User objects for the workspace.
        # @option options [Object] :start_cursor
        # Paginate through collections of data by setting the cursor parameter to a start_cursor attribute returned by a previous request's next_cursor. Default value fetches the first "page" of the collection. See pagination for more detail.
        def users_list(options = {})
          if block_given?
            Pagination::Cursor.new(self, :users_list, options).each do |page|
              yield page
            end
          else
            get("users?start_cursor=#{options[:start_cursor]}")
          end
        end
      end
    end
  end
end