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

  it 'should be able to define notification type' do
    class TestNotification < Notifi::Notification; end
    class Thing
      include Mongoid::Document
      include Notifi
      acts_as_subscribable notification_class: TestNotification
    end

    user = User.create
    thing = Thing.create

    user.subscribe_to thing

    thing.notify

    user.notifications.first.should be_a TestNotification
  end
end
