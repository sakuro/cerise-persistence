# Cerise::Persistence

Simple persistence support for [Hanami applications](https://github.com/hanami/hanami)

## Installation

Add this line to
```rb
group :cli, :development, :production, :test do
    gem "cerise-persistence"
end

## Usage

### Entity

Inherit entity classes like:

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

Inherit repository classes like:

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
- generator

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
