# frozen_string_literal: true
module Notion
  module Faraday
    module Connection
      private

      def connection
        @connection ||=
          begin
            options = {
              headers: { 'Accept' => 'application/json; charset=utf-8' }
            }

            options[:headers]['User-Agent'] = user_agent if user_agent
            options[:proxy] = proxy if proxy
            options[:ssl] = { ca_path: ca_path, ca_file: ca_file } if ca_path || ca_file

            request_options = {}
            request_options[:timeout] = timeout if timeout
            request_options[:open_timeout] = open_timeout if open_timeout
            options[:request] = request_options if request_options.any?

            ::Faraday::Connection.new(endpoint, options) do |connection|
              connection.use ::Faraday::Multipart::Middleware
              connection.use ::Faraday::Request::UrlEncoded
              connection.use ::Notion::Faraday::Response::RaiseError
              connection.use ::Faraday::Mashify::Middleware, mash_class: Notion::Messages::Message
              connection.use ::Faraday::Response::Json
              connection.use ::Notion::Faraday::Response::WrapError
              connection.response :logger, logger if logger
              connection.adapter adapter
            end
          end
      end
    end
  end
end
