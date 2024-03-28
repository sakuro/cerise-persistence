# frozen_string_literal: true

require "hanami/cli"

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
          "#{root}/cerise/persistence/version.rb"
        )
      end
    end

    gem_loader.setup

    require_relative "persistence/version"

    if Hanami::CLI.within_hanami_app?
      Hanami::CLI.after "install", Commands::Install
      # Hanami::CLI.register "generate entity", Commands::Generate::Entity
      # Hanami::CLI.register "generate relation", Commands::Generate::Relation
      # Hanami::CLI.register "generate repository", Commands::Generate::Repository
    end
  end
end
