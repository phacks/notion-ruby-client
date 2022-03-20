# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Pages do
  let(:client) { Notion::Client.new }
  let(:database_id) { 'dd428e9d-d3fe-4171-870d-a7a1902c748b' }
  let(:page_id) { 'c7fd1abe-8114-44ea-be77-9632ea33e581' }
  let(:property_id) { '%5BIFC' }
  let(:properties) do
    {
      "Name": {
        "title": [
          {
            "text": {
              "content": 'Another Notion page'
            }
          }
        ]
      }
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
      response = client.page(page_id: page_id)
      expect(response.properties.Name.type).to eql 'title'
      expect(response.properties.Name.title.first.plain_text).to eql 'Nicolas Goutay'
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
              "content": 'Nicolas Goutay'
            }
          }
        ]
      }
      response = client.update_page(
        page_id: page_id,
        properties: properties
      )
      expect(response.properties.Name.title.first.plain_text).to eql 'Nicolas Goutay'
    end

    it 'retrieves a page property item', vcr: { cassette_name: 'page_property_item' } do
      response = client.page_property_item(page_id: page_id, property_id: property_id)
      expect(response.email).to eql 'nicolas@orbit.love'
    end
  end
end
