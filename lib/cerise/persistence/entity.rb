# frozen_string_literal: true

require "dry/struct"
require "rom/struct"

# @see Cerise::Entity
module Cerise
  # @see Cerise::Entity
  module Persistence
    # Base class of entities
    class Entity < ROM::Struct
    end
  end
end
