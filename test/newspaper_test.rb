# frozen_string_literal: true

require "test_helper"

class NewspaperTest < Test::Unit::TestCase
  class UserSignupNotifier
    def call(payload)
      $MESSAGES << 'user signup!'
    end
  end

  $MESSAGES = []

  setup do
    $MESSAGES = []
  end

  test ".subscribe" do
    notifier = UserSignupNotifier.new
    Newspaper.subscribe(:user_create, notifier)
    assert_equal notifier, Newspaper.event_bus[:user_create]
  end

  test ".publish" do
    Newspaper.subscribe(:user_create, UserSignupNotifier.new)
    Newspaper.publish(:user_create, { name: 'foo' })
    assert_equal 'user signup!', $MESSAGES.last
  end

  test ".event_bus" do
    notifier = UserSignupNotifier.new
    Newspaper.subscribe(:user_create, notifier)
    event_bus = { user_create: notifier }
    assert_equal event_bus, Newspaper.event_bus
  end
end
