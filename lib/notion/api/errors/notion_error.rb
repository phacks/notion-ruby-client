# frozen_string_literal: true
module Notion
  module Api
    module Errors
      class NotionError < ::Faraday::Error
        attr_reader :response

        def initialize(message, details, response = nil)
          super("#{message} #{details}")
          @response = response
        end
      end
    end
  end
end