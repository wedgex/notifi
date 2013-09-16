module Notifi
  class Subscription
    include Mongoid::Document

    has_many :notifications, dependent: :destroy, inverse_of: :subscription

    def notify
      self.subscribable.notification_class.create(subscription: self,
                                                  subscriber: self.subscriber,
                                                  subscribable: self.subscribable)
    end
  end
end
