module Notifi
  module Subscriber
    def self.included(base)
      base.has_many :subscriptions, class_name: Subscription.name, dependent: :destroy, inverse_of: :subscriber
      base.has_many :triggered_notifications, class_name: Notification.name, dependent: :destroy, inverse_of: :notifier
      base.has_many :notifications, class_name: Notification.name, dependent: :destroy, inverse_of: :subscriber

      base.extend ClassMethods
    end

    def subscribe_to(subscribable)
      reject_non_subscribable! subscribable

      sub = self.subscriptions.find_or_initialize_by(subscriber: self, subscribable: subscribable)

      if sub.new_record?
        sub.save
        sub
      end
    end

    def unsubscribe_from(subscribable)
      reject_non_subscribable! subscribable

      self.subscriptions.destroy_all(subscribable: subscribable)
    end

    module ClassMethods
      def on_notification(&block)
        self.notification_event = block
      end
    end

    private
    def reject_non_subscribable!(target)
      unless target.kind_of? Subscribable
        raise ArgumentError, "#{target.class} does not include Notifi::Subscribable"
      end
    end
  end
end
