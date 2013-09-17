[![Code Climate](https://codeclimate.com/github/wedgex/notifi.png)](https://codeclimate.com/github/wedgex/notifi)

# Notifi

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'notifi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install notifi

## Usage

### Basic subscription & notification
Setup subscribers and subscribable models:
~~~~~ Ruby
class User
    include Mongoid::Document

    # Include notifi base
    include Notifi

    # setup user as a subscriber
    acts_as_subscriber
end

class Post
    include Mongoid::Document

    # Include notifi base
    include Notifi

    # setup posts as subscribable
    acts_as_subscribable
end
~~~~

You now have the ability to subscribe users to posts and notify users through the subscriptions.
~~~~ Ruby
post = Post.create
user = User.create

user.subscribe_to post

user.notifications.count # => 0

post.notify

user.notifications.count # => 1
~~~~

### On notification events

~~~ Ruby
class User
  include Mongoid::Document
  include Notifi

  acts_as_subscriber

  on_notification do |notification|
    # Do some sweet notification stuff here. Like maybe queue up an email
    # or print a smiley face to the log.
  end
end
~~~

The block provided to on_notification in your subscriber class will be called after a notification for the subscriber is created.


### Custom notification classes.

You can customize notifications by extending the Notification class and configuring the subscribable to use the custom class for notifications.

~~~ Ruby
class CommentNotification < Notifi::Notification
  field :message, type: String
end

class Comment
  include Mongoid::Document
  include Notifi

  acts_as_subscribable notification_class: CommentNotification

  after_create do
    self.notify
  end
end
~~~

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

