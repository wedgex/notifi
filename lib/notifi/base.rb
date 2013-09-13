module Notifi
  module Base
    def acts_as_subscriber
      Subscription.belongs_to :subscriber, class_name: self.to_s
      has_many :subscriptions, class_name: Subscription.to_s, dependent: :destroy, inverse_of: :subscriber

      Notification.belongs_to :subscriber, polymorphic: true
      has_many :notifications, class_name: Notification.to_s, dependent: :destroy, inverse_of: :subscriber do
        def mark_as_read
          self.each(&:mark_as_read)
        end
      end

      class_attribute :notification_event

      include Subscriber
    end

    def acts_as_subscribable
      Subscription.belongs_to :subscribable, polymorphic: true
      has_many :subscriptions, as: :subscribable, class_name: Subscription.to_s, dependent: :destroy

      Notification.belongs_to :subscribable, polymorphic: true
      has_many :notifications, as: :subscribable, class_name: Notification.to_s, dependent: :destroy

      include Subscribable
    end
  end
end
