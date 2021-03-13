[![CI](https://github.com/okuramasafumi/mruby-factory/actions/workflows/main.yml/badge.svg)](https://github.com/okuramasafumi/mruby-factory/actions/workflows/main.yml)

# mruby-factory

Factory implementation for mruby.

## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'okuramasafumi/mruby-factory'
end
```

## License
under the MIT License:
- see LICENSE file
