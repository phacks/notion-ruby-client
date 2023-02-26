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
          if block_given?
            Pagination::Cursor.new(self, :retrieve_comments, options).each do |page|
              yield page
            end
          else
            get('comments', options)
          end
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
        # @option options [Object] :parent
        #   A page parent. Either this or a discussion_id is required (not both).
        #
        # @option options [UUID] :discussion_id
        #   A UUID identifier for a discussion thread. Either this or a parent object is required (not both).
        #
        # @option options [Object] :rich_text
        #   A rich text object.
        def create_comment(options = {})
          if options.dig(:parent, :page_id).nil? && options[:discussion_id].nil?
            throw ArgumentError.new('Required argument :page_id or :discussion_id missing')
          end
          throw ArgumentError.new('Required argument :rich_text missing') if options[:rich_text].nil?
          post('comments', options)
        end
      end
    end
  end
end
