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

  context 'subscribe_to' do
    it 'should create a subscription' do
      subscriber.subscribe_to(subscribable)

      subscriber.subscriptions.count.should eq 1
    end

    it 'should throw exception if not given a subscribeble' do
      -> { subscriber.unsubscribe_from(Object.new) }.should raise_error(ArgumentError)
    end

    it 'should not create duplicate subscriptions' do
      subscriber.subscribe_to subscribable
      subscriber.subscribe_to subscribable

      subscriber.subscriptions.count.should eq 1
    end

    it 'should return a Subscription if subscription create' do
      subscription = subscriber.subscribe_to subscribable

      subscription.should be_an_instance_of Notifi::Subscription
    end

    it 'should not return a Subscription if subscription already exists' do
      subscriber.subscribe_to subscribable
      subscription = subscriber.subscribe_to subscribable

      subscription.should be nil
    end
  end



  context 'unsubscribe_from' do
    it 'should be able to unsubscribe' do
      subscriber.subscribe_to subscribable

      subscriber.unsubscribe_from subscribable

      subscriber.subscriptions.inspect

      subscriber.subscriptions.count.should eq 0
    end

    it 'should throw exception if not given a subscribeble' do
      -> { subscriber.unsubscribe_from(Object.new) }.should raise_error(ArgumentError)
    end
  end

  context 'on_notification' do
    it 'should be called when notification is created' do
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
  end
end
