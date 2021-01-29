# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Users
        #
        # Gets information about a user.
        #
        # @option options [id] :id
        #   User to get info on.
        def user(options = {})
          throw ArgumentError.new('Required arguments :id missing') if options[:id].nil?
          get("users/#{options[:id]}")
        end
      end
    end
  end
end