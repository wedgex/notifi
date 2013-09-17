module Notifi
  class Subscription
    include Mongoid::Document

    belongs_to :subscriber, polymorphic: true
    belongs_to :subscribable, polymorphic: true
    has_many :notifications, dependent: :destroy, inverse_of: :subscription

    def notify(options={})
      options[:subscription] = self
      options[:subscriber] = self.subscriber
      options[:subscribable] = self.subscribable

      self.subscribable.notification_class.create(options)
    end
  end
end
