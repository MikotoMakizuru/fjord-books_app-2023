# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    user = User.new(email: 'foo@example.com', name: '')
    assert_equal 'foo@example.com', user.name_or_email

    user = User.new(email: 'foo@example.com', name: 'foo')
    assert_equal 'foo', user.name_or_email
  end
end
