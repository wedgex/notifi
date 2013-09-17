module Notifi
  module Base
    def acts_as_subscriber
      class_attribute :notification_event

      include Subscriber
    end

    def acts_as_subscribable(notification_class: Notification)
      class_attribute :notification_class
      self.notification_class = notification_class

      include Subscribable
    end
  end
end
