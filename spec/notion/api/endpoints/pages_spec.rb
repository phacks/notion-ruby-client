# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Pages do
  let(:client) { Notion::Client.new }
  let(:database_id) { 'ab7e7b22-7793-492a-ba6b-3295f8b19341' }
  let(:page_id) { '2de466f0-9861-466b-9bc2-c987965da010' }
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
      },
      "Description": {
        "rich_text": [
          {
            "text": {
              "content": 'Page description'
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
        page_id: page_id,
        properties: properties
      )
      expect(response.properties.Name.title.first.plain_text).to eql 'A Notion page'
    end
  end
end
