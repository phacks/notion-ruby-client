# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Databases do
  let(:client) { Notion::Client.new }
  let(:database_id) { '89b30a70-ce51-4646-ab4f-5fdcb1d5e76c' }
  let(:page_id) { '7cbf38f8-5921-4422-bd3f-a647c3e2544b' }
  let(:title) do
    [
      {
        "text": {
          "content": 'Another Notion database'
        }
      }
    ]
  end
  let(:properties) do
    {
      "Name": {
        "title": {}
      }
    }
  end

  context 'databases' do
    it 'retrieves', vcr: { cassette_name: 'database' } do
      response = client.database(id: database_id)
      expect(response.title.first.plain_text).to eql 'A Notion database'
    end

    it 'queries', vcr: { cassette_name: 'database_query' } do
      response = client.database_query(id: database_id)
      expect(response.results.length).to be >= 1
    end

    it 'creates', vcr: { cassette_name: 'create_database' } do
      response = client.create_database(
        parent: { page_id: page_id },
        title: title,
        properties: properties
      )
      expect(response.title.first.plain_text).to eql 'Another Notion database'
    end

    it 'paginated queries', vcr: { cassette_name: 'paginated_database_query' } do
      pages = []
      client.database_query(id: database_id, limit: 1) do |page|
        pages.concat page.results
      end
      expect(pages.size).to be >= 1
    end

    it 'lists', vcr: { cassette_name: 'databases_list' } do
      response = client.databases_list
      expect(response.results.length).to be >= 1
    end

    it 'paginated lists', vcr: { cassette_name: 'paginated_databases_list' } do
      databases = []
      client.databases_list(limit: 1) do |page|
        databases.concat page.results
      end
      expect(databases.size).to be >= 1
    end
  end
end