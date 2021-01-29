# frozen_string_literal: true

require_relative 'endpoints/databases'
require_relative 'endpoints/users'

module Notion
  module Api
    module Endpoints
      include Databases
      include Users
    end
  end
end