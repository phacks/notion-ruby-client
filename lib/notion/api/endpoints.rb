# frozen_string_literal: true

require_relative 'endpoints/blocks'
require_relative 'endpoints/databases'
require_relative 'endpoints/pages'
require_relative 'endpoints/users'

module Notion
  module Api
    module Endpoints
      include Blocks
      include Databases
      include Pages
      include Users
    end
  end
end