require 'notifi'
require 'database_cleaner'

ENV["MONGOID_ENV"] = 'test'
Mongoid.load!(File.dirname(__FILE__) + '/mongoid.yml')

class User
  include Mongoid::Document
  include Notifi

  acts_as_subscriber
end

class Post
  include Mongoid::Document
  include Notifi

  acts_as_subscribable
end

class CommentNotification < Notifi::Notification
  field :comment, type: String
end

class Comment
  include Mongoid::Document
  include Notifi

  acts_as_subscribable default: CommentNotification
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
