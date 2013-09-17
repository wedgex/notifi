module Notifi
  module Base
    def acts_as_subscriber
      class_attribute :notification_event

      include Subscriber
    end

    def acts_as_subscribable(subscribable_options={})
      class_attribute :subscribable_options
      self.subscribable_options = subscribable_options

      include Subscribable
    end
  end
end
