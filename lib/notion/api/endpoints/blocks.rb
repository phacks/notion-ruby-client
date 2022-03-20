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
        # Updates the content for the specified block_id based on
        # the block type. Supported fields based on the block object
        # type (see Block object for available fields and the
        # expected input for each field).
        #
        # @option options [id] :block_id
        #   Block to get children info on.
        #
        # @option options [string] {type}
        #   The block object type value with the properties to be
        #   updated. Currently only text (for supported block types)
        #   and checked (for to_do blocks) fields can be updated.
        def update_block(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          patch("blocks/#{options[:block_id]}", options.except(:block_id))
        end

        #
        # Sets a Block object, including page blocks, to archived: true
        # using the ID specified. Note: in the Notion UI application, this
        # moves the block to the "Trash" where it can still be accessed and
        # restored.
        #
        # To restore the block with the API, use the Update a block or
        # Update page respectively.
        #
        # @option options [id] :block_id
        #   Block to get children info on.
        def delete_block(options = {})
          throw ArgumentError.new('Required arguments :block_id missing') if options[:block_id].nil?
          delete("blocks/#{options[:block_id]}")
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
            get("blocks/#{options[:block_id]}/children", options.except(:block_id))
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
          patch("blocks/#{options[:block_id]}/children", options.except(:block_id))
        end
      end
    end
  end
end
