# frozen_string_literal: true

require_relative "newspaper/version"

module Newspaper
  class Error < StandardError; end

  @event_bus = {}

  class << self
    attr_reader :event_bus

    def subscribe(event, subscriber)
      @event_bus[event] = subscriber
    end

    def publish(event, payload)
      subscriber = @event_bus[event]
      subscriber.call(payload)
    end

    def clear(event)
      @event_bus.delete event
    end

    def clear_all
      @event_bus = {}
    end
  end
end
