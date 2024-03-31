# frozen_string_literal: true

require "erb"
require "uri/generic"

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

        ENVIRONMENTS = %w(development test).freeze
        private_constant :ENVIRONMENTS

        # Installs base Entity and Persistence classes
        #
        # - app/entity.rb - base class of application's entities
        # - app/repository.rb - base class of application's repositories
        # @api private
        def call(*, **)
          create_app_entity_rb
          create_app_repository_rb
          append_database_url_setting
          append_database_url_envvar
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

        private def append_database_url_setting
          fs.inject_line_at_class_bottom("config/settings.rb", /Settings/, <<~SETTING)
            setting :database_url, constructor: Types::String
          SETTING
        end

        private def append_database_url_envvar
          ENVIRONMENTS.each do |env|
            url = URI::Generic.build(
              scheme: "postgres",
              userinfo: [ENV.fetch("PG_USER", "USER"), "postgres"].join(":"),
              host: ENV.fetch("PG_HOST", "localhost"),
              port: ENV.fetch("PG_PORT", "5432"),
              path: "/#{context.underscored_app_name}_#{env}"
            )

            fs.append(".env.#{env}.local", <<~DOTENV)
              DATABASE_URL=#{url}
            DOTENV
          end
        end
      end
    end
  end
end
