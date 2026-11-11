require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all
     def sign_in_as(user)
      post session_url, params: { session: { email: user.email_address, password: "secret123" } }
    end
  end
end
