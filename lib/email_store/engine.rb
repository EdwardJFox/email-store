require 'will_paginate'

module EmailStore
  class Engine < ::Rails::Engine
    isolate_namespace EmailStore
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
