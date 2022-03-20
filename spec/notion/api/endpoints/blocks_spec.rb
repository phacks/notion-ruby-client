# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Blocks do
  let(:client) { Notion::Client.new }
  let(:block_id) { '32af3324-ba02-4516-ae88-5728a4d569f4' }
  let(:children) do
    [
      {
        'object': 'block',
        'type': 'paragraph',
        'paragraph': {
          'text': [
            {
              'type': 'text',
              'text': {
                'content': 'Another children'
              }
            }
          ]
        }
      }
    ]
  end

  context 'blocks' do
    it 'retrieves', vcr: { cassette_name: 'block' } do
      response = client.block(block_id: block_id)
      expect(response).not_to be_empty
    end

    it 'updates', vcr: { cassette_name: 'update_block' } do
      to_do = {
        'text': [
          {
            'text': { 'content': 'A todo' }
          }
        ],
        'checked': true
      }
      to_do_block_id = '6e842658-eb3d-4ea9-9bbf-e86104151729'
      response = client.update_block(block_id: to_do_block_id, 'to_do' => to_do)
      expect(response.id).to eql to_do_block_id
    end

    it 'deletes', vcr: { cassette_name: 'delete_block' } do
      block_id = '77b5d405a5e840229c70b7766d1e8c4b'
      response = client.delete_block(block_id: block_id)
      expect(response).not_to be_empty
    end

    it 'children', vcr: { cassette_name: 'block_children' } do
      response = client.block_children(block_id: block_id)
      expect(response.results.length).to be >= 1
      expect(response.results[0].paragraph.text.first.plain_text).to eql 'The first child'
      expect(response.results[1].paragraph.text.first.plain_text).to eql 'The second child'
    end

    it 'paginated children', vcr: { cassette_name: 'paginated_block_children' } do
      children = []
      client.block_children(block_id: block_id, page_size: 1) do |page|
        children.concat page.results
      end
      expect(children.size).to be >= 1
    end

    it 'appends', vcr: { cassette_name: 'block_append_children' } do
      response = client.block_append_children(block_id: block_id, children: children)
      expect(response.results.first.type).to eql 'paragraph'
    end
  end
end