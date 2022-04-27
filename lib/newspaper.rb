# frozen_string_literal: true

require_relative "newspaper/version"

module Newspaper
  class Error < StandardError; end

  class << self
    def publish(event, payload)
    end

    def subscribe(event, subscriber)
    end

    def clear(event)
    end

    def clear_all

    end
  end
end
