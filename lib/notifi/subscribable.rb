module Notifi
  module Subscribable
    def self.included(base)
      base.extend ClassMethods
    end

    def notify(options={})
      subscriptions.each do |s|
        s.notify(options)
      end
    end

    module ClassMethods; end
  end
end
