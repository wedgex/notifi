require 'mongoid'

require 'notifi/version'
require 'notifi/base'
require 'notifi/subscription'
require 'notifi/notification'
require 'notifi/subscribable'
require 'notifi/subscriber'

module Notifi
  def self.included(base)
    base.extend Base
  end
end
