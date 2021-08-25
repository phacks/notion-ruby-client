# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Pagination::Cursor do
  let(:client) { Notion::Client.new }

  context 'default cursor' do
    let(:cursor) { described_class.new(client, 'users_list', {}) }

    it 'handles blank response metadata' do
      expect(client).to receive(:users_list).once.and_return(Notion::Messages::Message.new)
      cursor.to_a
    end

    it 'handles nil response metadata' do
      expect(client).to(
        receive(:users_list).once.and_return(Notion::Messages::Message.new(response: nil))
      )
      cursor.to_a
    end

    it 'paginates with a cursor inside response metadata' do
      expect(client).to receive(:users_list).twice.and_return(
        Notion::Messages::Message.new(has_more: true, next_cursor: 'next'),
        Notion::Messages::Message.new
      )
      expect(cursor).not_to receive(:sleep)
      cursor.to_a
    end

    context 'with rate limiting' do
      let(:error) { Notion::Api::Errors::TooManyRequests.new({}) }

      context 'with default max retries' do
        it 'sleeps after a TooManyRequestsError' do
          expect(client).to(
            receive(:users_list)
              .with({})
              .ordered
              .and_return(Notion::Messages::Message.new({ has_more: true, next_cursor: 'next' }))
          )
          expect(client).to(
            receive(:users_list).with(start_cursor: 'next').ordered.and_raise(error)
          )
          expect(cursor).to receive(:sleep).once.ordered.with(10)
          expect(client).to(
            receive(:users_list)
              .with(start_cursor: 'next')
              .ordered
              .and_return(Notion::Messages::Message.new)
          )
          cursor.to_a
        end
      end

      context 'with a custom max_retries' do
        let(:cursor) { described_class.new(client, 'users_list', max_retries: 4) }

        it 'raises the error after hitting the max retries' do
          expect(client).to(
            receive(:users_list)
              .with({})
              .and_return(Notion::Messages::Message.new({ has_more: true, next_cursor: 'next' }))
          )
          expect(client).to(
            receive(:users_list).with(start_cursor: 'next').exactly(5).times.and_raise(error)
          )
          expect(cursor).to receive(:sleep).exactly(4).times.with(10)
          expect { cursor.to_a }.to raise_error(error)
        end
      end

      context 'with a custom retry_after' do
        let(:cursor) { described_class.new(client, 'users_list', retry_after: 5) }

        it 'sleeps for retry_after seconds after a TooManyRequestsError' do
          expect(client).to(
            receive(:users_list)
              .with({})
              .ordered
              .and_return(Notion::Messages::Message.new({ has_more: true, next_cursor: 'next' }))
          )
          expect(client).to(
            receive(:users_list).with(start_cursor: 'next').ordered.and_raise(error)
          )
          expect(cursor).to receive(:sleep).once.ordered.with(5)
          expect(client).to(
            receive(:users_list)
              .with(start_cursor: 'next')
              .ordered
              .and_return(Notion::Messages::Message.new)
          )
          cursor.to_a
        end
      end
    end
  end

  context 'with a custom sleep_interval' do
    let(:cursor) { described_class.new(client, 'users_list', sleep_interval: 3) }

    it 'sleeps between requests' do
      expect(client).to receive(:users_list).exactly(3).times.and_return(
        Notion::Messages::Message.new(has_more: true, next_cursor: 'next_a'),
        Notion::Messages::Message.new(has_more: true, next_cursor: 'next_b'),
        Notion::Messages::Message.new
      )
      expect(cursor).to receive(:sleep).with(3).twice
      cursor.to_a
    end
  end
end