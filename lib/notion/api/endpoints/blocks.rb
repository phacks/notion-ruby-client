# frozen_string_literal: true

module Notion
  module Api
    module Endpoints
      module Blocks
        #
        # Retrieves a Block object using the ID specified.
        #
        # @option options [id] :block_id
        #   Block to get children info on.
        def block(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          get("blocks/#{options[:block_id]}")
        end

        #
        # Returns a paginated array of Block objects contained in the
        # block of the requested path using the ID specified.
        #
        # Returns a 404 HTTP response if any of the following are true:
        # - the ID does not exist
        # - the bot doesn't have access to the block with the given ID
        #
        # Returns a 400 or 429 HTTP response if the request exceeds Notion's Request limits.
        #
        # @option options [id] :block_id
        #   Block to get children info on.
        def block_children(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          if block_given?
            Pagination::Cursor.new(self, :block_children, options).each do |page|
              yield page
            end
          else
            get("blocks/#{options[:block_id]}/children", options)
          end
        end

        #
        # Creates and appends new children blocks to the parent block
        # in the requested path using the ID specified. Returns the Block
        # object being appended to.
        #
        # Returns a 404 HTTP response if any of the following are true:
        # - the ID does not exist
        # - the bot doesn't have access to the block with the given ID
        #
        # Returns a 400 or 429 HTTP response if the request exceeds Notion's Request limits.
        #
        # @option options [id] :block_id
        #   Block to append children to.
        #
        # @option options [[Object]] :children
        #   Children blocks to append
        def block_append_children(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          patch("blocks/#{options[:block_id]}/children", options)
        end
      end
    end
  end
end
