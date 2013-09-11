require 'mongoid'

require 'notifi/version'
require 'notifi/base'
require 'notifi/notification'
require 'notifi/subscribable'
require 'notifi/subscriber'
require 'notifi/subscription'

module Notifi
  def self.included(base)
    base.extend Base
  end
end
