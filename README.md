# mruby-factory   [![Build Status](https://travis-ci.org/okuramasafumi/mruby-factory.svg?branch=master)](https://travis-ci.org/okuramasafumi/mruby-factory)
Factory class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'okuramasafumi/mruby-factory'
end
```
## example
```ruby
p Factory.hi
#=> "hi!!"
t = Factory.new "hello"
p t.hello
#=> "hello"
p t.bye
#=> "hello bye"
```

## License
under the MIT License:
- see LICENSE file
