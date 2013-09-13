module Notifi
  module Subscribable
    def self.included(base)
      base.extend ClassMethods
    end

    def notify(message='')
      subscriptions.each do |s|
        s.notify(message)
      end
    end

    module ClassMethods; end
  end
end
