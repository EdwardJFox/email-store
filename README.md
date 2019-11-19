# EmailStore

Intercepts emails and stores them for viewing in the browser

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'email_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_store


To restrict unauthorised access to the stored emails please mount the engine in:

    config/routes.rb

appropriately using your specific restrictions:
```ruby
authenticated :user, ->(user) { user.staff? } do
  mount EmailStore::Engine, at: "/email_store"
end
```

Run the install command to copy the migrations over to your app:

    rails email_store:install:migrations

Run the migrations:

    rails db:migrate SCOPE=email_store

## Usage

Emails sent in QA and DEMO environment will be automatically intercepted and stored to be previewed at:

    /email_store/emails

## Warning

Performing deliveries with

    deliver!

will bypass the email interception and cause the email to be delivered!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
