# frozen_string_literal: true

require "hanami"
require "rom"
require "rom/repository"
require "zeitwerk"

# @see Cerise::Persistence::Repository
module Cerise
  # @see Cerise::Persistence::Repository
  module Persistence
    # Base class of repositories
    class Repository < ROM::Repository::Root
      auto_struct true

      def self.inherited(repo)
        super

        app_namespace = Hanami.app.app_name.namespace_name
        inflector = Hanami.app["inflector"]

        repo.struct_namespace inflector.constantize("#{app_namespace}::Entities")
      end

      private_class_method :inherited
    end
  end
end
