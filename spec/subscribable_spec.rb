require 'spec_helper'

describe 'subscribable' do
  let(:subscribable) { Post.create }

  it 'should be able to notify all subscribers' do
    subscribers = [User.create, User.create]

    subscribers.each { |s| s.subscribe_to subscribable }

    subscribable.notify

    subscribers.each do |s|
      s.notifications.length.should eq 1
    end
  end

  it 'should be able to provide a notifier' do
    user = User.create
    comment = Comment.create

    user.subscribe_to comment

    comment.notify(notifier: user)

    user.notifications.first.notifier.should eq user
  end

  context 'custom notifications' do
    it 'should be able to define notification type' do
      user = User.create
      comment = Comment.create

      user.subscribe_to comment

      comment.notify

      user.notifications.first.should be_a CommentNotification
    end

    it 'should be able to set fields on notification' do
      user = User.create
      comment = Comment.create

      user.subscribe_to comment

      message = 'HELLO'

      comment.notify(set: {comment: message})

      user.notifications.first.comment.should eq message
    end

    it 'should be able to define notifications for different events' do
      user = User.create
      class Thing
        include Mongoid::Document
        include Notifi

        acts_as_subscribable default: Notifi::Notification, test: CommentNotification
      end
      thing = Thing.create
      user.subscribe_to thing
      thing.notify :test
      user.notifications.first.should be_a CommentNotification
    end

    it 'should fall back to default notification type if event not provided' do
      user = User.create
      class Thing
        include Mongoid::Document
        include Notifi

        acts_as_subscribable default: CommentNotification
      end
      thing = Thing.create
      user.subscribe_to thing
      thing.notify
      user.notifications.first.should be_a CommentNotification
    end

    it 'should fall back to default notification type if event not found' do
      user = User.create
      class Thing
        include Mongoid::Document
        include Notifi

        acts_as_subscribable default: CommentNotification
      end
      thing = Thing.create
      user.subscribe_to thing
      thing.notify :test
      user.notifications.first.should be_a CommentNotification
    end
  end

  it 'should be able to provide a namespaced notification' do
    module Notification
      class Comment < Notifi::Notification; end
    end

    class Thing
      include Mongoid::Document
      include Notifi

      acts_as_subscribable default: Notification::Comment
    end

    user = User.create
    thing = Thing.create
    user.subscribe_to thing
    thing.notify
    user.notifications.first.should be_a Notification::Comment
  end
end
