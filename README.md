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

To integrate your bot with Notion, you must first create a new Notion Bot. (**TODO**: link to the docs)

1. Log into the workspace that you want your integration to be associated with.
2. Confirm that you are an Admin in the workspace (see Settings & Members > Members).
3. Go to Settings & Members, and click API

![A screenshot of the Notion page to create a bot](screenshots/create_notion_bot.png)

### Declare the API token

```
Notion.configure do |config|
  config.token = ENV['NOTION_API_TOKEN']
end
```

### API Client

TODO: document endpoints
