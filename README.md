# Cerise::Persistence

Simple persistence support for [Hanami applications](https://github.com/hanami/hanami)

## Installation

Add this line to
```rb
gem "cerise-persistence"

## Usage

### Entity

Create app/entity.rb:

```rb
# auto_register: false
# frozen_string_literal: true

require "cerise/persistence/entity"

module Bookshelf
  class Entity < Cerise::Persistence::Entity
  end
end
```

and inherit entity classes like:

```rb
module Bookshelf
  module Entities
    class Book < Bookshelf::Entity
    end
  end
end
```

It is a subclass of `ROM::Struct`.

### Repository

create app/repository.rb:

```rb
# auto_register: false
# frozen_string_literal: true

require "cerise/persistence/repository"

module Bookshelf
  class Repository < Cerise::Persistence::Repository
    # This will be unnecessary in the future
    include Deps[container: "persistence.rom"]
  end
end
```

and inherit repository classes like:

```
module Bookshelf
  module Repositories
    class BookRepo < Cerise::Repository[:books]
    end
  end
end
```

## ToDo

- provider
- install command
  - create app/entity.rb
  - create app/repository.rb
- generator

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
