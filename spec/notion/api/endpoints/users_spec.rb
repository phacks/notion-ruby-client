# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Users do
  let(:client) { Notion::Client.new }

  context 'users' do
    it 'me', vcr: { cassette_name: 'users_me' } do
      response = client.me
      expect(response.name).to eql 'Notion to Orbit'
    end

    it 'lists', vcr: { cassette_name: 'users_list' } do
      response = client.users_list
      expect(response.results.size).to be 1
    end

    it 'paginated list', vcr: { cassette_name: 'paginated_users_list' } do
      members = []
      client.users_list(page_size: 1) do |page|
        members.concat page.results
      end
      expect(members.size).to eq 1
    end

    it 'retrieves', vcr: { cassette_name: 'users' } do
      response = client.user(user_id: 'a8da8d30-c858-4c3d-87ad-3f2d477bd98d')
      expect(response.name).to eql 'Nicolas Goutay'
    end
  end
end