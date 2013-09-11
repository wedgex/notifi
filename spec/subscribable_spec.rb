require 'spec_helper'

describe 'subscribable' do
  let(:subscribable) { Post.create }

  it 'should add message to notifications' do
    subscriber = User.create
    subscriber.subscribe_to subscribable

    message = 'NOTIFIED!'

    subscribable.notify(message)

    subscriber.notifications.first.message.should eq message
  end

  it 'should be able to notify all subscribers' do
    subscribers = [User.create, User.create]

    subscribers.each { |s| s.subscribe_to subscribable }

    subscribable.notify

    subscribers.each do |s|
      s.notifications.length.should eq 1
    end
  end
end
