# frozen_string_literal: true

require "tmpdir"

require "dry/files"

RSpec.describe Cerise::Persistence::Commands::Install, type: :cli do
  describe "#call" do
    subject(:install) { described_class.new(fs:) }

    let(:fs) { Dry::Files.new }
    let(:dir) { Dir.mktmpdir }
    let(:inflector) { Dry::Inflector.new }

    let(:app_words) { Faker::Lorem.words(number: Faker::Number.between(from: 1, to: 3)) }
    let(:underscored_app_name) { inflector.underscore(app_words.join("-")) }
    let(:camelized_app_name) { inflector.camelize(app_words.join("-")) }

    let(:arbitrary_argument) { {} }

    let(:envs) { %w(development test) }

    def with_envvars(changes)
      original = ENV.to_h
      changes.each {|k, v| ENV[k.to_s] = v.to_s }

      begin
        yield
      ensure
        ENV.replace(original)
      end
    end

    around do |example|
      fs.chdir(dir) do
        fs.mkdir(underscored_app_name)
        fs.chdir(underscored_app_name) do
          fs.write("config/settings.rb", <<~SETTING)
            module #{camelized_app_name}
              class Settings < Hanami::Settings
              end
            end
          SETTING
          example.run
        end
      end
    ensure
      fs.delete_directory(dir)
    end

    it "creates app/entity.rb" do
      install.call(arbitrary_argument)

      expect(fs.read("app/entity.rb")).to include(<<~ENTITY_RB)
        # auto_register: false
        # frozen_string_literal: true

        require "cerise/persistence/entity"

        # @see #{camelized_app_name}::Entity
        module #{camelized_app_name}
          # Base class of #{camelized_app_name} entities
          class Entity < Cerise::Persistence::Entity
          end
        end
      ENTITY_RB
    end

    it "creates app/repository.rb" do
      install.call(arbitrary_argument)

      expect(fs.read("app/repository.rb")).to include(<<~REPOSITORY_RB)
        # auto_register: false
        # frozen_string_literal: true

        require "cerise/persistence/repository"

        # @see #{camelized_app_name}::Repository
        module #{camelized_app_name}
          # Base class of #{camelized_app_name} repositories
          class Repository < Cerise::Persistence::Repository
            include Deps[container: "persistence.rom"]
          end
        end
      REPOSITORY_RB
    end

    it "creates database_url setting" do
      with_envvars(PG_USER: "postgres", PG_HOST: "localhost", PG_PORT: "5432") do
        install.call(arbitrary_argument)
      end

      expect(fs.read("config/settings.rb")).to include(<<~SETTING)
        setting :database_url, constructor: Types::String
      SETTING

      envs.each do |env|
        expect(fs.read(".env.#{env}.local")).to include <<~DOTENV
          DATABASE_URL=postgres://postgres:postgres@localhost:5432/#{underscored_app_name}_#{env}
        DOTENV
      end
    end
  end
end
