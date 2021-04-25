# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Pages do
  let(:client) { Notion::Client.new }
  let(:database_id) { '89b30a70-ce51-4646-ab4f-5fdcb1d5e76c' }
  let(:page_id) { '723578f1-6e51-450c-8ee1-09158c19fd4c' }
  let(:properties) do
    {
      "Name": [
        {
          "text": {
            "content": 'Another Notion page'
          }
        }
      ]
    }
  end
  let(:children) do
    [
      {
        "object": 'block',
        "type": 'heading_2',
        "heading_2": {
          "text": [{ "type": 'text', "text": { "content": 'A heading' } }]
        }
      }
    ]
  end

  context 'pages' do
    it 'retrieves', vcr: { cassette_name: 'page' } do
      response = client.page(id: page_id)
      expect(response.properties.Name.type).to eql 'title'
      expect(response.properties.Name.title.first.plain_text).to eql 'A Notion page'
    end

    it 'creates', vcr: { cassette_name: 'create_page' } do
      response = client.create_page(
        parent: { database_id: database_id },
        properties: properties,
        children: children
      )
      expect(response.properties.Name.title.first.plain_text).to eql 'Another Notion page'
    end

    it 'updates', vcr: { cassette_name: 'update_page' } do
      properties = {
        "Name": [
          {
            "text": {
              "content": 'A Notion page'
            }
          }
        ]
      }
      response = client.update_page(
        id: page_id,
        properties: properties
      )
      expect(response.properties.Name.title.first.plain_text).to eql 'A Notion page'
    end
  end
end
