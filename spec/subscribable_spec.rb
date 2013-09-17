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

      comment.notify(comment: message)

      user.notifications.first.comment.should eq message
    end
  end
end
