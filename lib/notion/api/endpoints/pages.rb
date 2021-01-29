# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Pages
        #
        # Retrieves a 📄Page object  using the ID specified in the request path.
        # Note that this version of the API only exposes page properties, not page content
        #
        # @option options [id] :id
        #   User to get info on.
        #
        # @option options [bool] :archived
        #   Set to true to retrieve an archived page; must be false or omitted to
        #   retrieve a page that has not been archived. Defaults to false.
        def page(options = {})
          throw ArgumentError.new('Required arguments :id missing') if options[:id].nil?
          get("pages/#{options[:id]}?archived=#{options[:archived]}")
        end
      end
    end
  end
end
