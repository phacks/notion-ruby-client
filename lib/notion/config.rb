# frozen_string_literal: true
module Notion
  module Config
    extend self

    ATTRIBUTES = %i[
      proxy
      user_agent
      ca_path
      ca_file
      logger
      endpoint
      token
      timeout
      open_timeout
      default_page_size
      default_max_retries
      default_retry_after
      adapter
    ].freeze

    attr_accessor(*Config::ATTRIBUTES)

    def reset
      self.endpoint = 'https://api.notion.com/v1'
      self.user_agent = "Notion Ruby Client/#{Notion::VERSION}"
      self.ca_path = nil
      self.ca_file = nil
      self.token = nil
      self.proxy = nil
      self.logger = nil
      self.timeout = nil
      self.open_timeout = nil
      self.default_page_size = 100
      self.default_max_retries = 100
      self.default_retry_after = 10
      self.adapter = ::Faraday.default_adapter
    end

    reset
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end

Notion::Config.reset
