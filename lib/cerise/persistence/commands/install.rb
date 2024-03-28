# frozen_string_literal: true

require "erb"

require "dry/files"
require "dry/inflector"

require "hanami/cli/command"
require "hanami/cli/generators/context"

# @see Cerise::Persistence::Commands::Install
module Cerise
  # @see Cerise::Persistence::Commands::Install
  module Persistence
    # @see Cerise::Persistence::Commands::Install
    module Commands
      # @api private
      class Install < Hanami::CLI::Command
        def initialize(...)
          super(...)
          app = File.basename(Dir.pwd)
          @context = Hanami::CLI::Generators::Context.new(inflector, app)
        end

        attr_reader :context

        # Installs base Entity and Persistence classes
        #
        # - app/entity.rb - base class of application's entities
        # - app/repository.rb - base class of application's repositories
        # @api private
        def call(*, **)
          create_app_entity_rb
          create_app_repository_rb
        end

        private def create_app_entity_rb
          content = fs.read(
            fs.expand_path(fs.join("..", "generators", "entity.rb.erb"), __dir__)
          )

          fs.write(
            fs.expand_path("app/entity.rb"),
            ERB.new(content, trim_mode: "-").result(context.ctx)
          )
        end

        private def create_app_repository_rb
          content = fs.read(
            fs.expand_path(fs.join("..", "generators", "repository.rb.erb"), __dir__)
          )
          fs.write(
            fs.expand_path("app/repository.rb"),
            ERB.new(content, trim_mode: "-").result(context.ctx)
          )
        end
      end
    end
  end
end
