# cane-hashcheck

`cane-hashcheck` enforces Ruby 1.9 hash syntax in your Ruby project using
[cane](https://github.com/square/cane).

## Description

If you no longer like hash rockets, `cane-hashcheck` is for you. For example,
see this ugliness?

```ruby
# person.rb
def options
  {
    :name => 'Bob',
    :age => 30,
    :location => 'Seattle'
  }
end
```

When we run our quality rake task, we are scolded for using the old hash syntax
and encouraged to make a change on three lines:

```bash
$ rake quality
Ruby 1.9 hash syntax violation (3):

  person.rb:3
  person.rb:4
  person.rb:5

  Total Violations: 3
```

Ah, much better:

```ruby
# person.rb
def options
  {
    name: 'Bob',
    age: 30,
    location: 'Seattle'
  }
end
```

## Usage

Add `cane-hashcheck` to your project's Gemfile:

```ruby
gem 'cane-hashcheck'
```

Use the `Cane::HashCheck` in your quality rake task:

```ruby
require 'cane/hashcheck'

desc 'Check code quality'
Cane::RakeTask.new(:quality) do |task|
  task.use Cane::HashCheck
end
```

Check code quality using rake:

```bash
$ rake quality
```

See the [cane project](https://github.com/square/cane) for general usage
instructions.

## Contributing
Please see the [Contributing
Document](https://github.com/chrishunt/cane-hashcheck/blob/master/CONTRIBUTING.md)

## Changelog
Please see the [Changelog
Document](https://github.com/chrishunt/cane-hashcheck/blob/master/CHANGELOG.md)

## License
Copyright (C) 2013 Chris Hunt, [MIT
License](https://github.com/chrishunt/cane-hashcheck/blob/master/LICENSE.txt)
