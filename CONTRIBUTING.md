# CONTRIBUTING

_This project is intended to be a safe, welcoming space for collaboration. By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md)._

Hi there! We're thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

## Running the project

### GitHub Codespaces

This repository includes configuration for GitHub Codespaces, making it easy to set up a cloud-based development environment. Follow [GitHub's guide](https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace#creating-a-codespace) to get started.

The Codespaces environment has the dependencies all installed, and should be ready to tinker with. Once your Codespace is set up, you can check that everything works as intended by running the specs:

```
bundle exec rake
```

### Running the project locally

You can also install the project on your machine:

```
git clone https://github.com/phacks/notion-ruby-client.git
cd notion-ruby-client
# if you do not have bundler installed already, run
# $ gem install bundle
# to install it
bundle install
```

You can check that everything works as intended by running the specs:

```
bundle exec rake
```

## Interactive console

You can run

```
bin/console
```

to start an IRB (interactive Ruby console) session with all the gem files loaded.
Usually, you’d start such sessions by defining your `client`:

```
client = Notion::Client.new(token: <Your Notion API token>)
```
