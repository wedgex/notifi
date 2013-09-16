module Notifi
  module Subscribable
    def self.included(base)
      base.extend ClassMethods
    end

    def notify
      subscriptions.each do |s|
        s.notify
      end
    end

    module ClassMethods; end
  end
end
