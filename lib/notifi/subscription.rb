module Notifi
  class Subscription
    include Mongoid::Document

    has_many :notifications, dependent: :delete_all, inverse_of: :subscription

    def notify(message = '')
      self.notifications.create(subscriber: self.subscriber,
                               subscribable: self.subscribable,
                               message: message)
    end
  end
end
