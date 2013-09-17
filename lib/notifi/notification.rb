module Notifi
  class Notification
    include Mongoid::Document

    belongs_to :subscription
    belongs_to :subscriber, polymorphic: true
    belongs_to :subscribable, polymorphic: true

    field :read, type: Boolean, default: false
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

    def mark_as_read
      self.update_attribute :read, true
    end
  end
end
