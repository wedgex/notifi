module Notifi
  module Subscriber
    module InstanceMethods
      def subscribe_to(subscribable)
        self.subscriptions.find_or_create_by(subscribable: subscribable)
      end

      def unsubscribe_from(subscribable)
        self.subscriptions.destroy_all(subscribable: subscribable)
      end
    end

    module ClassMethods
      def on_notification(&block)
        self.notification_event = block
      end
    end
  end
end
