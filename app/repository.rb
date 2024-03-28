# auto_register: false
# frozen_string_literal: true

require "cerise/persistence/repository"

# @see CerisePersistence::Repository
module CerisePersistence
  # Base class of CerisePersistence repositories
  class Repository < Cerise::Persistence::Repository
    include Deps[container: "persistence.rom"]
  end
end
