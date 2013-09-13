module Notifi
  module Subscriber
    def self.included(base)
      base.extend ClassMethods
    end

    def subscribe_to(subscribable)
      reject_non_subscribable! subscribable

      self.subscriptions.find_or_create_by(subscribable: subscribable)
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
