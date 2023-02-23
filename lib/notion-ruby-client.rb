# frozen_string_literal: true
require 'faraday'
require 'faraday/mashify'
require 'faraday/multipart'
require 'json'
require 'logger'
require 'hashie'

require_relative 'notion/version'
require_relative 'notion/logger'
require_relative 'notion/config'

# Messages
require_relative 'notion/messages/message'

require_relative 'notion/config'
require_relative 'notion/api/errors/notion_error'
require_relative 'notion/api/error'
require_relative 'notion/api/errors'
require_relative 'notion/api/errors/internal_error'
require_relative 'notion/api/errors/too_many_requests'
require_relative 'notion/faraday/response/raise_error'
require_relative 'notion/faraday/response/wrap_error'
require_relative 'notion/faraday/connection'
require_relative 'notion/faraday/request'
require_relative 'notion/api/endpoints'
require_relative 'notion/pagination/cursor'
require_relative 'notion/client'
