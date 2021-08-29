# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Databases do
  let(:client) { Notion::Client.new }
  let(:database_id) { 'dd428e9dd3fe4171870da7a1902c748b' }
  let(:page_id) { 'c7fd1abe811444eabe779632ea33e581' }
  let(:title) do
    [
      {
        "text": {
          "content": 'Orbit 💜 Notion'
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
    it 'queries', vcr: { cassette_name: 'database_query' } do
      response = client.database_query(database_id: database_id)
      expect(response.results.length).to be >= 1
    end

    it 'paginated queries', vcr: { cassette_name: 'paginated_database_query' } do
      pages = []
      client.database_query(database_id: database_id, page_size: 1) do |page|
        pages.concat page.results
      end
      expect(pages.size).to be >= 1
    end

    it 'creates', vcr: { cassette_name: 'create_database' } do
      response = client.create_database(
        parent: { page_id: page_id },
        title: title,
        properties: properties
      )
      expect(response.title.first.plain_text).to eql 'Orbit 💜 Notion'
    end

    it 'updates', vcr: { cassette_name: 'update_database' } do
      response = client.update_database(
        database_id: database_id,
        title: title
      )
      expect(response.title.first.plain_text).to eql 'Orbit 💜 Notion'
    end

    it 'retrieves', vcr: { cassette_name: 'database' } do
      response = client.database(database_id: database_id)
      expect(response.title.first.plain_text).to eql 'Orbit 💜 Notion'
    end

    it 'lists', vcr: { cassette_name: 'databases_list' } do
      response = client.databases_list
      expect(response.results.length).to be >= 1
    end

    it 'paginated lists', vcr: { cassette_name: 'paginated_databases_list' } do
      databases = []
      client.databases_list(page_size: 1) do |page|
        databases.concat page.results
      end
      expect(databases.size).to be >= 1
    end
  end
end