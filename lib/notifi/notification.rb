module Notifi
  class Notification
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :subscription, index: true
    belongs_to :subscriber, polymorphic: true, index: true
    belongs_to :notifier, polymorphic: true, index: true
    belongs_to :subscribable, polymorphic: true, index: true

    field :message, type: String

    after_create do |n|
      n.fire_notification_event
    end

    def notification_event?
      self.subscriber && self.subscriber.notification_event
    end

    def fire_notification_event
      self.subscriber.notification_event.call(self) if self.notification_event?
    end
  end
end
