# frozen_string_literal: true
module Notion
  module Api
    module Endpoints
      module Comments
        #
        # Retrieves a list of un-resolved Comment objects from a page or block.
        #
        # @option options [id] :block_id
        #   Block or page id to fetch comments for.
        #
        # @option options [start_cursor] :start_cursor
        #   If supplied, this endpoint will return a page
        #   of results starting after the cursor provided.
        #   If not supplied, this endpoint will return the
        #   first page of results.
        #
        # @option options [page_size] :page_size
        #   The number of items from the full list desired in the response.
        #   Maximum: 100
        #
        def retrieve_comments(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          params = "block_id=#{options[:block_id]}"
          params += "&start_cursor=#{options[:start_cursor]}" unless options[:start_cursor].nil?
          params += "&page_size=#{options[:page_size]}"       unless options[:page_size].nil?
          get("comments?#{params}")
        end

        #
        # Creates a comment in a page or existing discussion thread.
        #   There are two locations you can add a new comment to:
        #     - A page
        #     - An existing discussion thread
        #   If the intention is to add a new comment to a page, a parent object
        #   must be provided in the body params. Alternatively, if a new comment
        #   is being added to an existing discussion thread, the discussion_id string
        #   must be provided in the body params. Exactly one of these parameters must be provided.
        #
        # @option options [id] :page_id
        #   Page to add the comment to.
        #
        # @option options [Object] :comment
        #   Properties of this page.
        #   The schema for the page's keys and values is described by the properties of
        #   the database this page belongs to. key string Name of a property as it
        #   appears in Notion, or property ID. value object Object containing a value
        #   specific to the property type, e.g. {"checkbox": true}.
        def create_comment(options = {})
          if options[:page_id].nil? && options[:discussion_id].nil?
            throw ArgumentError.new('Required argument :page_id or :discussion_id')
          end
          post('comments', formatted_comment(options))
        end

        def formatted_comment(options)
          comment_hash = { rich_text: [{ text: { content: options[:comment] } }] }
          if options.key?(:discussion_id)
            comment_hash[:discussion_id] = options[:discussion_id]
          else
            comment_hash[:parent] = { page_id: options[:page_id] }
          end
          comment_hash
        end
      end
    end
  end
end
