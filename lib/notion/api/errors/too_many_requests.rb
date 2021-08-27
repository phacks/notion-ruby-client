# frozen_string_literal: true
module Notion
  module Api
    module Errors
      class TooManyRequests < ::Faraday::Error
        attr_reader :response

        def initialize(response)
          @response = response
          super 'Too many requests'
        end
      end
    end
  end
end
