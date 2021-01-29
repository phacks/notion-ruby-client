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
      end
    end
  end
end