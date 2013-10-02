module Notifi
  class Subscription
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :subscriber, polymorphic: true
    belongs_to :subscribable, polymorphic: true
    has_many :notifications, dependent: :destroy, inverse_of: :subscription

    def notify(event=:default, notifier=nil, set: {})
      set[:subscription] = self
      set[:notifier] = notifier
      set[:subscriber] = self.subscriber
      set[:subscribable] = self.subscribable

      self.notification_class(event).create(set)
    end

    def subscribable_options
      self.subscribable.subscribable_options
    end

    def notification_class(event)
      subscribable_options[event] || subscribable_options[:default] || Notification
    end
  end
end
