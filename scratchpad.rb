Notion.configure do |config|
  config.token = ENV['NOTION_API_TOKEN']
end

client = Notion::Client.new(token: 'token')


client = Notion::Client.new
client.auth_test

client.database(id)
client.database_query(id, options)

client.page(id)
client.create_page(options)
client.update_page(id, options)

client.user(id)
client.list_users(options)


# https://c15c8970-daea-4c88-9bcd-93726522a93e.mock.pstmn.io