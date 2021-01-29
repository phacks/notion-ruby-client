# frozen_string_literal: true
module Notion
  module Api
    module Errors
      class NotionError < ::Faraday::Error
        attr_reader :response

        def initialize(message, response = nil)
          super message
          @response = response
        end
      end
    end
  end
end