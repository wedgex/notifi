module Notifi
  module Subscribable
    def self.included(base)
      base.has_many :subscriptions, as: :subscribable,
                                    class_name: Subscription.to_s,
                                    dependent: :destroy,
                                    inverse_of: :subscribable

      base.has_many :notifications, as: :subscribable,
                                    class_name: base.notification_class.to_s,
                                    dependent: :destroy,
                                    inverse_of: :subscribable
    end

    def notify(options={})
      self.subscriptions.each { |s| s.notify(options) }
    end
  end
end
