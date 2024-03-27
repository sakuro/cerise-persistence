# frozen_string_literal: true

require_relative "persistence/entity"
require_relative "persistence/repository"
require_relative "persistence/version"

# @see Serise::Persistence
module Cerise
  # @api private
  module Persistence
    # @api private
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "cerise-persistence"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/cerise-persistence.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/cerise-persistence.rb",
          "#{root}/cerise-persistence/entity.rb",
          "#{root}/cerise-persistence/repository.rb",
          "#{root}/cerise/persistence/version.rb"
        )
      end
    end

    gem_loader.setup
  end
end
