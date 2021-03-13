MRuby::Gem::Specification.new('mruby-factory') do |spec|

  spec.license = 'MIT'
  spec.authors = 'OKURA Masafumi'

  spec.add_dependency 'mruby-class-ext'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-hash-ext'
  spec.add_dependency 'mruby-metaprog'
  spec.add_dependency 'mruby-enumerator'
end
