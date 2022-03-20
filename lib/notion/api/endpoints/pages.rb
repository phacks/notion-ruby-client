# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Pages
        #
        # Retrieves a 📄Page object  using the ID specified in the request path.
        # Note that this version of the API only exposes page properties, not page content
        #
        # @option options [id] :page_id
        #   Page to get info on.
        #
        # @option options [bool] :archived
        #   Set to true to retrieve an archived page; must be false or omitted to
        #   retrieve a page that has not been archived. Defaults to false.
        def page(options = {})
          throw ArgumentError.new('Required argument :page_id missing') if options[:page_id].nil?
          get("pages/#{options[:page_id]}")
        end

        #
        # Creates a new page in the specified database.
        # Later iterations of the API will support creating pages outside databases.
        # Note that this iteration of the API will only expose page properties, not
        # page content, as described in the data model.
        #
        # @option options [Object] :parent
        #   Parent of the page, which is always going to be a database in this version of the API.
        #
        # @option options [Object] :properties
        #   Properties of this page.
        #   The schema for the page's keys and values is described by the properties of
        #   the database this page belongs to. key string Name of a property as it
        #   appears in Notion, or property ID. value object Object containing a value
        #   specific to the property type, e.g. {"checkbox": true}.
        #
        # @option options [Object] :children
        #   An optional array of Block objects representing the Page’s content
        def create_page(options = {})
          throw ArgumentError.new('Required argument :parent.database_id missing') if options.dig(:parent, :database_id).nil?
          post("pages", options)
        end

        #
        # Updates a page by setting the values of any properties specified in the
        # JSON body of the request. Properties that are not set via parameters will
        # remain unchanged.
        #
        # Note that this iteration of the API will only expose page properties, not page
        # content, as described in the data model.
        #
        # @option options [id] :page_id
        #   Page to get info on.
        #
        # @option options [Object] :properties
        #   Properties of this page.
        #   The schema for the page's keys and values is described by the properties of
        #   the database this page belongs to. key string Name of a property as it
        #   appears in Notion, or property ID. value object Object containing a value
        #   specific to the property type, e.g. {"checkbox": true}.
        def update_page(options = {})
          throw ArgumentError.new('Required argument :page_id missing') if options[:page_id].nil?
          patch("pages/#{options[:page_id]}", options.except(:page_id))
        end

        #
        # Retrieves a `property_item` object for a given `page_id` and `property_id`.
        # Depending on the property type, the object returned will either be a value
        # or a paginated list of property item values.
        #
        # @option options [id] :page_id
        #   Page to get info on.
        #
        # @option options [id] :property_id
        #   Property to get info on.
        #
        def page_property_item(options = {})
          throw ArgumentError.new('Required argument :page_id missing') if options[:page_id].nil?
          throw ArgumentError.new('Required argument :property_id missing') if options[:property_id].nil?
          get("pages/#{options[:page_id]}/properties/#{options[:property_id]}")
        end
      end
    end
  end
end
