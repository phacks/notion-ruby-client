# frozen_string_literal: true
module Notion
  module Faraday
    module Request
      def get(path, options = {})
        request(:get, path, options)
      end

      def patch(path, options = {})
        request(:patch, path, options)
      end

      def post(path, options = {})
        request(:post, path, options)
      end

      def put(path, options = {})
        request(:put, path, options)
      end

      def delete(path, options = {})
        request(:delete, path, options)
      end

      private

      def request(method, path, options)
        response = connection.send(method) do |request|
          request.headers['Authorization'] = "Bearer #{token}"
          request.headers['Notion-Version'] = Notion::NOTION_REQUEST_VERSION
          case method
          when :get, :delete
            request.url(path, options)
          when :post, :put, :patch
            request.headers['Content-Type'] = 'application/json'
            request.path = path
            request.body = options.to_json unless options.empty?
          end
          request.options.merge!(options.delete(:request)) if options.key?(:request)
        end
        response.body
      end
    end
  end
end