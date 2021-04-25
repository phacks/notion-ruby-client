# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Blocks do
  let(:client) { Notion::Client.new }
  let(:page_id) { '723578f1-6e51-450c-8ee1-09158c19fd4c' }
  let(:children) do
    [
      {
        "object": 'block',
        "type": 'heading_2',
        "heading_2": {
          "text": [{ "type": 'text', "text": { "content": 'Another Heading' } }]
        }
      }
    ]
  end

  context 'blocks' do
    it 'children', vcr: { cassette_name: 'block_children' } do
      response = client.block_children(id: page_id)
      expect(response.results.length).to be >= 1
      expect(response.results[0].heading_1.text.first.plain_text).to eql 'A Header'
      expect(response.results[1].paragraph.text.first.plain_text).to eql 'A paragraph'
    end

    it 'paginated children', vcr: { cassette_name: 'paginated_block_children' } do
      children = []
      client.block_children(id: page_id, page_size: 1) do |page|
        children.concat page.results
      end
      expect(children.size).to be >= 1
    end

    it 'appends', vcr: { cassette_name: 'block_append_children' } do
      response = client.block_append_children(id: page_id, children: children)
      expect(response.id).to eql page_id
    end
  end
end