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

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes, with tests (`git commit -am 'Add some feature'`)
4. Run the tests (`bundle exec rake`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
