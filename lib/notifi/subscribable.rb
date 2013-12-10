module Notifi
  module Subscribable
    def self.included(base)
      base.has_many :subscriptions, as: :subscribable,
                                    class_name: Subscription.name,
                                    dependent: :destroy,
                                    inverse_of: :subscribable

      base.has_many :notifications, as: :subscribable,
                                    class_name: Notification.name,
                                    dependent: :destroy,
                                    inverse_of: :subscribable
    end

    def notify(event=:default, notifier: nil, set: {})
      self.subscriptions.each { |s| s.notify(event, notifier: notifier, set: set) }
    end
  end
end
