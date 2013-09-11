module Notifi
  module Subscribable
    module InstanceMethods
      def notify(message='')
        subscriptions.each do |s|
          s.notify(message)
        end
      end
    end

    module ClassMethods
    end
  end
end
