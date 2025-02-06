# frozen_string_literal: true

module UniversalAccess
  class Engine < ::Rails::Engine
    isolate_namespace UniversalAccess

    config.generators do |generator|
      generator.test_framework :rspec
      generator.fixture_replacement :factory_bot
      generator.factory_bot dir: 'spec/factories'
    end
  end
end
