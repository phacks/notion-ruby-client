# Notion Ruby Client

A Ruby client for the Notion API.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Create a New Bot Integration](#create-a-new-bot-integration)
  - [Declare the API Token](#declare-the-api-token)
  - [API Client](#api-client)

## Installation

Add to Gemfile.

```
gem 'notion-ruby-client'
```

Run `bundle install`.

## Usage

### Create a New Bot Integration

To integrate your bot with Notion, you must first [create a new Notion Bot](https://www.notion.so/Getting-started-da32a6fc1bcc4403a6126ee735710d89).

1. Log into the workspace that you want your integration to be associated with.
2. Confirm that you are an Admin in the workspace (see Settings & Members > Members).
3. Go to Settings & Members, and click API

![A screenshot of the Notion page to create a bot](screenshots/create_notion_bot.png)

### Declare the API token

```ruby
Notion.configure do |config|
  config.token = ENV['NOTION_API_TOKEN']
end
```

For Rails projects, the snippet above would go to `config/application.rb`.

### API Client

#### Instanciating a new Notion API client

```ruby
client = Notion::Client.new
```

You can specify the token or logger on a per-client basis:

```ruby
client = Notion::Client.new(token: '<secret Notion API token>')
```

#### Users

Get a paginated list of [User objects](https://www.notion.so/User-object-4f8d1a2fc1e54680b5f810ed0c6903a6) for the workspace:

```ruby
client.users_list # retrieves the first page

client.users_list(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.users_list do |page|
  # paginate through all users
end
```

Get a single User:

```ruby
client.user(id: 'd40e767c-d7af-4b18-a86d-55c61f1e39a4')
```
