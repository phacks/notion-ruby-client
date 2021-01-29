# frozen_string_literal: true
module Notion
  class Client
    include Faraday::Connection
    include Faraday::Request
    include Api::Endpoints

    attr_accessor(*Config::ATTRIBUTES)

    def initialize(options = {})
      Notion::Config::ATTRIBUTES.each do |key|
        send("#{key}=", options.fetch(key, Notion.config.send(key)))
      end
      @logger ||= Notion::Config.logger || Notion::Logger.default
      @token ||= Notion.config.token
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
end