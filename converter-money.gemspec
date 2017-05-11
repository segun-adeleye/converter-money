# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'converter/money/version'

Gem::Specification.new do |spec|
  spec.name          = 'converter-money'
  spec.version       = Converter::Money::VERSION
  spec.authors       = ['Oluwasegun Adeleye']
  spec.email         = ['segun.adeleye@outlook.com']

  spec.summary       = 'A ruby currency converter'
  spec.description   = 'An easy to use Ruby gem that performs currency conversion and arithmetics with different currencies'
  spec.homepage      = 'https://github.com/segun-adeleye/converter-money'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
