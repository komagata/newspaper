# frozen_string_literal: true

require "test_helper"

class NewspaperTest < Test::Unit::TestCase
  class << self
    @messages = []
    attr_accessor :messages
  end

  class UserSignupNotifier
    def call(_payload)
      NewspaperTest.messages << "user signup!"
    end
  end

  class UserCountNotifier
    def call(_payload)
      NewspaperTest.messages << "2 users exists!"
    end
  end

  setup do
    NewspaperTest.messages = []
    Newspaper.clear_all
  end

  test ".subscribe" do
    notifier = UserSignupNotifier.new
    Newspaper.subscribe(:user_create, notifier)
    assert_equal notifier, Newspaper.event_bus[:user_create].first
  end

  test ".publish" do
    Newspaper.subscribe(:user_create, UserSignupNotifier.new)
    Newspaper.publish(:user_create, { name: "foo" })
    assert_equal "user signup!", NewspaperTest.messages.last
  end

  test "publish to multiple subscripers" do
    Newspaper.subscribe(:user_create, UserSignupNotifier.new)
    Newspaper.subscribe(:user_create, UserCountNotifier.new)
    Newspaper.publish(:user_create, { name: "foo" })
    assert_equal "2 users exists!", NewspaperTest.messages[-1]
    assert_equal "user signup!", NewspaperTest.messages[-2]
  end

  test ".event_bus" do
    notifier = UserSignupNotifier.new
    Newspaper.subscribe(:user_create, notifier)
    event_bus = { user_create: [notifier] }
    assert_equal event_bus, Newspaper.event_bus
  end
end
