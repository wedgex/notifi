require 'spec_helper'

describe 'notification' do
  let(:notification) { Notifi::Notification.create }

  it 'should default to unread' do
    notification.read?.should be false
  end

  it 'should be able to mark_as_read' do
    notification.mark_as_read

    notification.read?.should be true
  end
end
