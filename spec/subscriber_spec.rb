require 'spec_helper'

describe 'subscriber' do
  let(:subscriber) { User.create }
  let(:subscribable) { Post.create }

  it 'should have subscriptions' do
    # TODO figure out why shoulda matchers are blowing up and do this right
    subscriber.should respond_to(:subscriptions)
  end

  it 'should have notifications' do
    subscriber.should respond_to(:notifications)
  end

  it 'should be able to subscribe' do
    subscriber.subscribe_to(subscribable)

    subscriber.subscriptions.count.should eq 1
  end

  it 'should not create duplicate subscriptions' do
    subscriber.subscribe_to subscribable
    subscriber.subscribe_to subscribable

    subscriber.subscriptions.count.should eq 1
  end

  it 'should return a Subscription' do
    subscription = subscriber.subscribe_to subscribable

    subscription.should be_an_instance_of Notifi::Subscription
  end

  it 'should be able to unsubscribe' do
    subscriber.subscribe_to subscribable

    subscriber.unsubscribe_from subscribable

    subscriber.subscriptions.inspect

    subscriber.subscriptions.count.should eq 0
  end

  it 'should call on_notification block when notification is created' do
    class Thing
      include Mongoid::Document
      include Notifi

      acts_as_subscriber

      attr_accessor :notified

      @block_called = false
      on_notification do |notification|
        @block_called = true
      end
    end

    thing = Thing.create

    thing.subscribe_to subscribable
    thing.subscriptions.first.notify

    thing.class.instance_variable_get(:@block_called).should be true
  end

  it 'should be able to mark all notifications as read' do
    subscription = subscriber.subscribe_to subscribable

    subscription.notify
    subscription.notify

    subscriber.notifications.mark_as_read
  end
end
