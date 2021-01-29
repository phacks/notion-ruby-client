# frozen_string_literal: true

require_relative 'endpoints/users'

module Notion
  module Api
    module Endpoints
      include Users
    end
  end
end