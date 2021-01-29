# frozen_string_literal: true

module Notion
  module Api
    module Errors
      class InternalError < NotionError; end
      class InvalidRequest < NotionError; end
      class ObjectNotFound < NotionError; end
      class TooManyRequests < NotionError; end

      ERROR_CLASSES = {
        'internal_error' => InternalError,
        'invalid_request' => InvalidRequest,
        'object_not_found' => ObjectNotFound,
        'rate_limited' => TooManyRequests
      }.freeze
    end
  end
end